#
# Cookbook:: custom_modules
# Recipe:: configure_defaults
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:custom_modules][:web_root]
configurations = node[:custom_modules][:default_configuration]

unless configurations.empty?
    configurations.each do |setting|
        command_string = "#{web_root}/bin/magento config:set "
        config_string = "#{setting[:path]} \"#{setting[:value]}\""
        execute "Configuring custom module default setting : #{setting[:path]}" do
            command [command_string, config_string].join
        end
    end
end