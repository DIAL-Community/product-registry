# frozen_string_literal: true

module Modules
  module ConnectionSwitch
    def with_db(connection_spec_name)
      current_conf = ActiveRecord::Base.connection_config

      begin
        if database_changed?(connection_spec_name)
          ActiveRecord::Base.establish_connection(db_configurations[connection_spec_name]).tap do
            Rails.logger.debug "\e[1;35m [ActiveRecord::Base switched database] \e[0m #{ActiveRecord::Base.connection.current_database}"
          end
        end

        yield
      ensure
        if database_changed?(connection_spec_name, current_conf)
          ActiveRecord::Base.establish_connection(current_conf).tap do
            Rails.logger.debug "\e[1;35m [ActiveRecord::Base switched database] \e[0m #{ActiveRecord::Base.connection.current_database}"
          end
        end
      end
    end

    private

    def database_changed?(connection_spec_name, current_conf = nil)
      current_conf ||= ActiveRecord::Base.connection_config
      current_conf[:database] != db_configurations[connection_spec_name].try(:[], :database)
    end

    def db_configurations
      @db_config ||= begin
        file_name =  "#{Rails.root}/config/database.yml"
        config ||= if File.exist?(file_name) || File.symlink?(file_name)
                     HashWithIndifferentAccess.new(YAML.safe_load(ERB.new(File.read(file_name)).result))
                   else
                     HashWithIndifferentAccess.new
                   end

        config
      end
    end
  end
  ActiveRecord.extend ConnectionSwitch
end
