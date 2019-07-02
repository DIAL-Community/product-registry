namespace :db do
    task :run_if_no_db do
      begin
        Rake::Task['environment'].invoke
        ActiveRecord::Base.connection
      rescue
        exit 0
      else
        exit 1
      end
    end

    desc "returns appropriate exit code whether db exists or not"
    task :run_if_no_db do
      begin
        Rake::Task['environment'].invoke
        ActiveRecord::Base.connection
      rescue
        exit 0
      else
        exit 1
      end
    end

    desc "Dumps the database to db/backup/APP_NAME.dump"
    task :backup => :environment do
      cmd = nil
      with_config do |app, host, db, user, pass|
        cmd = "export PGPASSWORD=#{pass} && pg_dump --host #{host} --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/backups/#{app}.dump"
      end
      exec cmd
    end

    desc "Restores the database dump at db/APP_NAME.dump."
    task :restore => :environment do
      cmd = nil
      with_config do |app, host, db, user, pass|
        cmd = "export PGPASSWORD=#{pass} && pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/backups/#{app}.dump"
      end
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke
      exec cmd
    end

    desc "Creates a database the first time the app is run - from db/APP_NAME_init.dump."
    task :create_db_with_public_data => :environment do
      cmd = nil
      with_config do |app, host, db, user, pass|
        cmd = "export PGPASSWORD=#{pass} && pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/backups/#{app}_init.dump"
      end
      Rake::Task["db:create"].invoke
      exec cmd
    end

    desc "Export database minus proprietary data - this export can be provided to other customers"
    task :dump_public_db => :environment do
      cmd = nil
      with_config do |app, host, db, user, pass|
        cmd = "export PGPASSWORD=#{pass} && pg_dump --host #{host} --username #{user} --exclude-table-data=users --exclude-table-data=contacts --exclude-table-data=organizations_contacts --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/backups/#{app}_init.dump"
      end
      exec cmd
    end

    private

    def with_config
      yield Rails.application.class.parent_name.underscore,
        ActiveRecord::Base.connection_config[:host],
        ActiveRecord::Base.connection_config[:database],
        ActiveRecord::Base.connection_config[:username],
        ActiveRecord::Base.connection_config[:password]
    end

  end
