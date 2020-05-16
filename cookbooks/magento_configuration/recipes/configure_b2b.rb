#
# Cookbook:: magento_configuration
# Recipe:: configure_b2b
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_configuration][:user]
web_root = node[:magento_configuration][:web_root]
configurations = node[:magento_configuration][:user_configuration]

unless configurations.empty?
    command_string = "su #{user} -c '#{web_root}/bin/magento config:set"
    configurations.each do |setting|
        next unless setting[:path].include?("btob")
        next if (setting[:value].is_a? String) && (setting[:value].empty?)
        if setting.has_key?(:scope)
            scope_string = "--scope=#{setting[:scope]} --scope-code=#{setting[:code]}"
        end
        config_string = "#{setting[:path]} \"#{process_value(setting[:value])}\"'"
        execute "Configuring b2b setting : #{setting[:path]}" do
            command [command_string, scope_string, config_string].join(" ")
        end
    end
end