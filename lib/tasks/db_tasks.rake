# frozen_string_literal: true

require 'modules/track'
include(Modules::Track)

namespace :db do
  desc 'returns appropriate exit code whether db exists or not'
  task :run_if_no_db do
    Rake::Task['environment'].invoke
    ActiveRecord::Base.connection
  rescue StandardError
    exit(0)
  else
    exit(1)
  end

  desc 'Dumps the database to db/backup/APP_NAME.dump'
  task backup: :environment do
    start_tracking_task('Database Backup')
    cmd = nil
    with_config do |app, host, db, user, pass, port|
      cmd = "export PGPASSWORD='#{pass}' && pg_dump --host #{host} --username #{user} -p #{port} " \
            "       --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/backups/#{app}.dump"
    end
    exec cmd
  end

  desc 'Restores the database dump at db/APP_NAME.dump.'
  task restore: :environment do
    cmd = nil
    with_config do |app, host, db, user, pass, port|
      cmd = "export PGPASSWORD='#{pass}' && pg_restore --verbose --host #{host} --username #{user} -p #{port} " \
            "       --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/backups/#{app}.dump"
    end
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    exec cmd
  end

  desc 'Creates a database the first time the app is run - from db/APP_NAME_public.dump.'
  task create_db_with_public_data: :environment do
    cmd = nil
    with_config do |app, host, db, user, pass, port|
      cmd = "export PGPASSWORD='#{pass}' && pg_restore --verbose --host #{host} --username #{user} -p #{port} " \
            "       --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/backups/#{app}_public.dump"
    end
    Rake::Task['db:create'].invoke
    exec cmd
  end

  desc 'Export database minus proprietary data - this export can be provided to other customers'
  task dump_public_db: :environment do
    cmd = nil
    with_config do |app, host, db, user, pass, port|
      cmd = "export PGPASSWORD='#{pass}' && pg_dump --host #{host} --username #{user} -p #{port} " \
            '       --exclude-table-data=users ' \
            '       --exclude-table-data=users_products ' \
            '       --exclude-table-data=sessions ' \
            '       --exclude-table-data=contacts ' \
            '       --exclude-table-data=organizations_contacts ' \
            '       --verbose --clean --no-owner --no-acl ' \
            "       --format=c #{db} > #{Rails.root}/db/backups/#{app}_public.dump"
    end
    exec cmd
  end

  desc 'Send backup email to admin users that have receive_backup selected'
  task send_backup_emails: :environment do
    cmd = nil
    with_config do |_app, _host, _db, _user, _pass|
      users = User.where(receive_backup: true)
      users.each do |user|
        cmd = "curl -s --user 'api:#{Rails.application.secrets.mailgun_api_key}'" \
              "     https://api.mailgun.net/v3/#{Rails.application.secrets.mailgun_domain}/messages " \
              "     -F from='Registry <backups@solutions.dial.community>' -F to=#{user.email}" \
              "     -F subject='T4D Registry Backup' -F text='Registry dump file' " \
              '     -F attachment=@/t4d/db/backups/registry.dump'
        system cmd
      end
    end
  end

  desc 'Clean unused expired sessions.'
  task clear_expired_sessions: :environment do
    sql = "DELETE FROM sessions WHERE updated_at < (NOW() - INTERVAL '2 DAY');"
    ActiveRecord::Base.connection.execute(sql)
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username],
      ActiveRecord::Base.connection_config[:password],
      ActiveRecord::Base.connection_config[:port]
  end
end
