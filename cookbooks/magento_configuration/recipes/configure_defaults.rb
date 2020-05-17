#
# Cookbook:: magento_configuration
# Recipe:: configure_defaults
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_configuration][:user]
web_root = node[:magento_configuration][:web_root]
configurations = node[:magento_configuration][:settings][:defaults]

unless configurations.empty?
    configurations.each do |setting|
        next if (setting[:value].is_a? String) && (setting[:value].empty?)
        command_string = "su #{user} -c '#{web_root}/bin/magento config:set"
        config_string = "#{setting[:path]} \"#{process_value(setting[:value])}\"'"
        execute "Configuring default setting : #{setting[:path]}" do
            command [command_string, config_string].join(" ")
        end
    end
end