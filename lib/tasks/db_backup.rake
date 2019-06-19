namespace :db do

    desc "Dumps the database to db/backup/APP_NAME.dump"
    task :backup => :environment do
      cmd = nil
      with_config do |app, host, db, user, pass|
        cmd = "mkdir /t4d/db/backups && export PGPASSWORD=#{pass} && pg_dump --host #{host} --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/backups/#{app}.dump"
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

    desc "Export database minus proprietary data - this export can be provided to other customers"
    task :create_initial_db => :environment do
      cmd = nil
      with_config do |app, host, db, user, pass|
        cmd = "export PGPASSWORD=#{pass} && pg_dump --host #{host} --username #{user} --exclude-table-data=users --exclude-table-data=contacts --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/backups/#{app}_init.dump"
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