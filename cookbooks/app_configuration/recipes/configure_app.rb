#
# Cookbook:: app_configuration
# Recipe:: configure_app
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:app_configuration][:user]
web_root = node[:app_configuration][:web_root]
db_host = node[:app_configuration][:db_host]
db_user = node[:app_configuration][:db_user]
db_password = node[:app_configuration][:db_password]
db_name = node[:app_configuration][:db_name]
configurations = node[:app_configuration][:user_configuration]

unless configurations.empty?
    configurations.each do |setting|
        next if setting[:path].include?("btob") || setting[:path].include?("search")
        # There's no CLI command for the design/header/welcome path, so we update the database instead...
        if setting[:path].include?("welcome")
            ruby_block "Configuring default setting : #{setting[:path]}" do
                block do
                    if setting[:value].include?("'")
                        escaped_value = setting[:value].gsub("'", "''")
                    else
                        escaped_value = setting[:value]
                    end
                    connection_string = "mysql --user=#{db_user} --password=#{db_password} --database=#{db_name}"
                    query_string = "\"SELECT value FROM core_config_data WHERE path = '#{setting[:path]}';\""
                    select_result = %x[#{[connection_string, query_string].join(" -e ")}]
                    if select_result.empty?
                        query_string = "\"INSERT INTO core_config_data (scope, scope_id, path, value) VALUES('default', 0, '#{setting[:path]}', '#{escaped_value}');\""
                    else
                        query_string = "\"UPDATE core_config_data SET value='#{escaped_value}' WHERE path = '#{setting[:path]}';\""
                    end
                    # Execute the database query
                    %x[#{[connection_string, query_string].join(" -e ")}]
                end
                action :create
                sensitive true
            end
        else
            next if (setting[:value].is_a? String) && (setting[:value].empty?)
            command_string = "su #{user} -c '#{web_root}/bin/magento config:set"
            if setting.has_key?(:scope)
                scope_string = "--scope=#{setting[:scope]} --scope-code=#{setting[:code]}"
            end
            config_string = "#{setting[:path]} \"#{process_value(setting[:value])}\"'"
            execute "Configuring base setting : #{setting[:path]}" do
                command [command_string, scope_string, config_string].join(" ")
            end
        end
    end
end