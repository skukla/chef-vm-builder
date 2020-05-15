#
# Cookbook:: app_configuration
# Recipe:: configure_custom_modules
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:custom_modules][:web_root]
module_list = node[:custom_modules][:module_list]

unless module_list.nil?
    module_list.each do |module_key, module_data|
        next if module_data[:configuration].nil? 
        command_string = "#{web_root}/bin/magento config:set"
        module_data[:configuration].each do |setting|
            next if (setting[:value].is_a? String) && (setting[:value].empty?)
            config_string = "#{setting[:path]} \"#{process_value(setting[:value])}\""
            execute "Configuring custom module setting : #{setting[:path]}" do
                command [command_string, config_string].join(" ")
            end
        end
    end
end