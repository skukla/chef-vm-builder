#
# Cookbook:: magento_custom_modules
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# 
autofill_fields = [:enable, :label, :email_value, :password_value, :firstname_value, :lastname_value, :address_value, :city_value, :state_value, :zip_value, :country_value, :telephone_value, :company_value]
autofill_config_paths = Array.new
autofill_config_paths << "magentoese_autofill/general/enable_autofill"
[*1..17].each do |i|
    autofill_fields.each_with_index do |field, index|
        autofill_config_paths << "magentoese_autofill/persona_#{i}/#{field}"
    end
end
supported_modules = {
    :module_1 => {
        :config_paths =>  autofill_config_paths,
        :name => "magentoese/module-autofill"
    },
    :module_2 => {
        :config_paths => ["catalog/search/engine"],
        :name => "smile/elasticsuite",
        :configuration => {
            :catalog => {
                :search  => {
                    :engine => "elasticsuite"
                }
            }
        }
    }
}

configured_modules = node[:custom_demo][:custom_modules]
default_configurations = Array.new
module_list = Array.new

unless configured_modules.nil?
    configured_modules.select do |configured_key, configured_value|
        unless configured_value.nil?
            (configured_value.is_a? Hash) ? custom_module_name = configured_value[:name] : custom_module_name = configured_value
            selected_modules = supported_modules.select { |supported_key, supported_value| supported_value[:name] == custom_module_name }
            selected_modules.each do |selected_key, selected_value|
                custom_module_hash = Hash.new
                custom_module_hash[:package_name] = selected_value[:name]
                if selected_value[:name].include?("/")
                    custom_module_hash[:vendor] = selected_value[:name].split("/")[0]
                    custom_module_hash[:module_name] = selected_value[:name].split("/")[1]
                else
                    custom_module_hash[:vendor] = selected_value[:name]
                    custom_module_hash[:module_name] = selected_value[:name]
                end
                custom_module_hash[:config_paths] = selected_value[:config_paths]
                if selected_value.has_key?(:configuration)
                    selected_value[:config_paths].each do |config_path|
                        configuration_setting = Hash.new
                        setting_value = selected_value[:configuration].dig(*(config_path.split("/").map{ |segment| segment.to_sym }))
                        unless setting_value.nil?
                            configuration_setting[:path] = config_path
                            configuration_setting[:value] = setting_value
                            default_configurations << configuration_setting
                        end
                    end
                end
                custom_module_hash[:configuration] = default_configurations
                module_list << custom_module_hash
            end
        end
    end
    module_list.each do |module_data|
        default[:magento_custom_modules][:module_list][module_data[:package_name]] = module_data
    end
end
# If none of the OOB-supported modules are in use, set module_list to an empty hash
default[:magento_custom_modules][:module_list] = Hash.new if node[:magento_custom_modules].nil?