#
# Cookbook:: magento_custom_modules
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
configured_custom_modules = node[:custom_demo][:custom_modules]
user_configurations = Array.new
supported_settings = [:name, :version, :repository_url]

unless configured_custom_modules.nil?
    configured_custom_modules.each do |custom_key, custom_value|
        custom_module_hash = Hash.new
        if !custom_value.is_a? Hash
            if custom_value.include?("/")
                name = custom_value
                vendor = custom_value.split("/")[0]
                module_name = custom_value.split("/")[1]
            else
                name = custom_value
                vendor = custom_value
            end
            custom_module_hash[:name] = name
            custom_module_hash[:vendor] = vendor
            custom_module_hash[:module_name] = module_name
        else
            supported_settings.each do |setting|
                case setting
                when :version
                    if custom_value[setting].nil?
                        custom_module_hash[:version] = "dev-master"
                    else
                        custom_module_hash[:version] = custom_value[setting]
                    end
                when :name
                    unless custom_value[setting].nil?
                        custom_module_hash[setting] = custom_value[setting]
                        if custom_value[setting].include?("/")
                            custom_module_hash[:vendor] = custom_value[setting].split("/")[0]
                            custom_module_hash[:module_name] = custom_value[setting].split("/")[1]
                        else
                            custom_module_hash[:vendor] = custom_value[setting]
                            custom_module_hash[:module_name] = custom_value[setting]
                        end
                    end
                else
                    custom_module_hash[setting] = custom_value[setting]
                end
            end
        end
        user_configurations << custom_module_hash
    end
    user_configurations.each do |module_data|
        override[:magento_custom_modules][:module_list][module_data[:name]][:settings] = module_data
    end
end