#
# Cookbook:: magento_custom_modules
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_modules = node[:magento_custom_modules][:module_list]
supported_settings = [:name, :version, :repository_url]
configured_custom_modules = node[:custom_demo][:custom_modules]
module_list = Array.new
user_configurations = Array.new

unless configured_custom_modules.nil?
    configured_custom_modules.each do |custom_key, custom_value|
        custom_module_hash = Hash.new
        if !custom_value.is_a? Hash
            package_name = custom_value
            if custom_value.include?("/")
                vendor = custom_value.split("/")[0]
                module_name = custom_value.split("/")[1]
            else
                package_name = custom_value
                vendor = custom_value
            end
            custom_module_hash[:package_name] = package_name
            custom_module_hash[:vendor] = vendor
            custom_module_hash[:module_name] = module_name
        else
            supported_settings.each do |setting|
                case setting
                when :name
                    unless custom_value[setting].nil?
                        custom_module_hash[:package_name] = custom_value[setting]
                        if custom_value[setting].include?("/")
                            custom_module_hash[:vendor] = custom_value[setting].split("/")[0]
                            custom_module_hash[:module_name] = custom_value[setting].split("/")[1]
                        else
                            custom_module_hash[:vendor] = custom_value[setting]
                            custom_module_hash[:module_name] = custom_value[setting]
                        end
                    end
                when :version
                    if custom_value[setting].nil?
                        custom_module_hash[:package_version] = "dev-master"
                    else
                        custom_module_hash[:package_version] = custom_value[setting]
                    end
                else
                    custom_module_hash[setting] = custom_value[setting]
                end
            end
            if custom_value.has_key?(:configuration)
                supported_modules.each do |supported_key, supported_value|
                    if supported_value[:package_name] == custom_value[:name]
                        supported_config_paths = supported_value[:config_paths]
                    end
                    supported_value[:config_paths].each do |config_path|
                        configuration_setting = Hash.new
                        if config_path.include?("enable_autofill")
                            configuration_setting[:path] = config_path
                            configuration_setting[:value] = 1
                            user_configurations << configuration_setting
                        end
                        setting_value = custom_value[:configuration].dig(*(config_path.split("/").map{ |segment| segment.to_sym }))
                        unless setting_value.nil?
                            configuration_setting[:path] = config_path
                            configuration_setting[:value] = setting_value
                            user_configurations << configuration_setting                                
                        end
                    end
                    custom_module_hash[:configuration] = user_configurations
                end
            end
        end
        module_list << custom_module_hash
    end
    module_list.each do |module_data|
        override[:magento_custom_modules][:module_list][module_data[:package_name]] = module_data
    end
end