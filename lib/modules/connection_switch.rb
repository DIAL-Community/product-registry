module Modules
  module ConnectionSwitch
    def with_db(connection_spec_name)
      current_conf = ActiveRecord::Base.connection_config

      begin
        ActiveRecord::Base.establish_connection(db_configurations[connection_spec_name]).tap do
          Rails.logger.debug "\e[1;35m [ActiveRecord::Base switched database] \e[0m #{ActiveRecord::Base.connection.current_database}"
        end if database_changed?(connection_spec_name)

        yield
      ensure
        ActiveRecord::Base.establish_connection(current_conf).tap do
          Rails.logger.debug "\e[1;35m [ActiveRecord::Base switched database] \e[0m #{ActiveRecord::Base.connection.current_database}"
        end if database_changed?(connection_spec_name, current_conf)
      end

    end

    private
    def database_changed?(connection_spec_name, current_conf = nil)
      current_conf = ActiveRecord::Base.connection_config unless current_conf
      current_conf[:database] != db_configurations[connection_spec_name].try(:[], :database)
    end

    def db_configurations
      @db_config ||= begin
        file_name =  "#{Rails.root}/config/database.yml"
        if File.exists?(file_name) || File.symlink?(file_name)
          config ||= HashWithIndifferentAccess.new(YAML.load(ERB.new(File.read(file_name)).result))
        else
          config ||= HashWithIndifferentAccess.new
        end

        config
      end
    end
  end
  ActiveRecord.send :extend, ConnectionSwitch
end
