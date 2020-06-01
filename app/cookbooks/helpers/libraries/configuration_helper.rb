#
# Cookbook:: helpers
# Library:: configuration_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module ConfigurationHelper
    def self.config_set_db(config_path, config_value, db_user, db_password, db_name)
        ruby_block "Insert configuration directly into the database" do
            block do
                escaped_value = config_value.gsub("'", "''") ? config_value.include?("'") : escaped_value = config_value
                connection_string = "mysql --user=#{db_user} --password=#{db_password} --database=#{db_name}"
                query_string = "\"SELECT value FROM core_config_data WHERE path = '#{config_path}';\""
                select_result = %x[#{[connection_string, query_string].join(" -e ")}]
                if select_result.empty?
                    query_string = "\"INSERT INTO core_config_data (scope, scope_id, path, value) VALUES('default', 0, '#{config_path}', '#{escaped_value}');\""
                else
                    query_string = "\"UPDATE core_config_data SET value='#{escaped_value}' WHERE path = '#{config_path}';\""
                end
                # Execute the database query
                %x[#{[connection_string, query_string].join(" -e ")}]
            end
            action :create
            sensitive true
        end
    end 
end