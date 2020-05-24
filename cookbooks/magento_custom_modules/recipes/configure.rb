#
# Cookbook:: magento_custom_modules
# Recipe:: configure_custom_modules
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento_custom_modules][:web_root]
module_list = node[:magento_custom_modules][:module_list]

module_list.each do |module_key, module_data|
    unless module_data[:configuration].nil?
        module_data[:configuration].each do |setting|
            magento_cli "Configuring custom module setting : #{setting[:path]}" do
                action :config_set
                config_scope "default"
                config_path "\"#{setting[:path]}\""
                config_value "\"#{ValueHelper.process_value(setting[:value])}\""
                not_if {  ((setting[:value].is_a? String) && setting[:value].empty?) }
            end
        end
    end
end