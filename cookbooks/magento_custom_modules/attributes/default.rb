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
supported_custom_modules = {
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
configured_custom_modules = node[:custom_demo][:custom_modules]
module_configurations = Array.new

unless configured_custom_modules.nil?
    configured_custom_modules.select do |configured_key, configured_value|
        unless configured_value.nil?
            (configured_value.is_a? Hash) ? custom_module_name = configured_value[:name] : custom_module_name = configured_value
            selected_modules = supported_custom_modules.select { |supported_key, supported_value| supported_value[:name] == custom_module_name }
            selected_modules.each do |selected_key, selected_value|
                if selected_value.has_key?(:configuration)
                    selected_value[:config_paths].each do |config_path|
                        configuration_setting = Hash.new
                        setting_value = selected_value[:configuration].dig(*(config_path.split("/").map{ |segment| segment.to_sym }))
                        unless setting_value.nil?
                            configuration_setting[:path] = config_path
                            configuration_setting[:value] = setting_value
                            module_configurations << configuration_setting
                        end
                    end
                end
                default[:magento_custom_modules][:module_list][selected_value[:name]][:settings][:name] = selected_value[:name]
                if selected_value[:name].include?("/")
                    default[:magento_custom_modules][:module_list][selected_value[:name]][:settings][:vendor] = selected_value[:name].split("/")[0]
                    default[:magento_custom_modules][:module_list][selected_value[:name]][:settings][:module_name] = selected_value[:name].split("/")[1]
                else
                    default[:magento_custom_modules][:module_list][selected_value[:name]][:settings][:vendor] = selected_value[:name]
                    default[:magento_custom_modules][:module_list][selected_value[:name]][:settings][:module_name] = selected_value[:name]
                end
                default[:magento_custom_modules][:module_list][selected_value[:name]][:config_paths] = selected_value[:config_paths]
                default[:magento_custom_modules][:module_list][selected_value[:name]][:configuration] = module_configurations
            end
        end
    end
end