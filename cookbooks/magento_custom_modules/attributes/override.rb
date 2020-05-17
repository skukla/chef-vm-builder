#
# Cookbook:: magento_custom_modules
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default_custom_modules = node[:magento_custom_modules][:module_list]
configured_custom_modules = node[:custom_demo][:custom_modules]
user_configurations = Array.new
supported_settings = [:require, :version, :repository_url]

unless configured_custom_modules.nil?
    configured_custom_modules.each do |module_key, module_value|
        module_key.include?("-") ? escaped_module_key = module_key.gsub("-", "_") : escaped_module_key = module_key
        if configured_custom_modules[module_key].is_a? Chef::Node::ImmutableMash
            supported_settings.each do |setting|
                unless configured_custom_modules[module_key][setting].nil?
                    override[:magento_custom_modules][:module_list][escaped_module_key][:settings][setting] = configured_custom_modules[module_key][setting]
                end
            end
        else
            unless configured_custom_modules[module_key].empty?
                override[:magento_custom_modules][:module_list][escaped_module_key][:settings][:require] = configured_custom_modules[module_key]
            end
        end
        # Now we have the require statement value whether the setting is a hash or a string, so we can further parse it
        override[:magento_custom_modules][:module_list][escaped_module_key][:settings][:vendor] = node[:magento_custom_modules][:module_list][escaped_module_key][:settings][:require].split("/")[0]
        if node[:magento_custom_modules][:module_list][escaped_module_key][:settings][:require].include?("/")
            override[:magento_custom_modules][:module_list][escaped_module_key][:settings][:name] = node[:magento_custom_modules][:module_list][escaped_module_key][:settings][:require].split("/")[1]
        else
            override[:magento_custom_modules][:module_list][escaped_module_key][:settings][:name] = node[:magento_custom_modules][:module_list][escaped_module_key][:settings][:require]
        end
        # Now check for and process a configuration settings hash
        if configured_custom_modules[module_key]["configuration"].is_a? Chef::Node::ImmutableMash
            module_configurations = Array.new
            unless node[:magento_custom_modules][:module_list][escaped_module_key][:settings][:require].nil?
                module_name = node[:magento_custom_modules][:module_list][escaped_module_key][:settings][:name]
                module_name.include?("-") ? escaped_module_name = module_name.gsub("-", "_") : escaped_module_name = module_name
                default_custom_modules[escaped_module_name][:config_paths].each do |config_path|
                    configuration_setting = Hash.new
                    # Include the default setting for enabling autofill
                    if config_path.include?("enable_autofill")
                        configuration_setting[:path] = config_path
                        configuration_setting[:value] = 1
                        module_configurations << configuration_setting
                    end
                    setting_value = configured_custom_modules[module_key]["configuration"].dig(*config_path.split("/"))
                    unless setting_value.nil?
                        configuration_setting[:path] = config_path
                        configuration_setting[:value] = setting_value
                        module_configurations << configuration_setting
                    end
                end
            end
            override[:magento_custom_modules][:module_list][escaped_module_key][:configuration] = module_configurations
        end
    end
end