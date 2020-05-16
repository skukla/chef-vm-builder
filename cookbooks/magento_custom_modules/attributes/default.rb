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
    :module_autofill => {
        :config_paths =>  autofill_config_paths
    },
    :elasticsuite => {
        :config_paths => ["catalog/search/engine"],
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

unless configured_custom_modules.nil?
    supported_custom_modules.each do |module_key, module_data|
        module_configurations = Array.new
        module_data[:config_paths].each do |config_path|
            if module_data.has_key?(:configuration)
                configuration_setting = Hash.new
                setting_value = module_data[:configuration].dig(*(config_path.split("/").map{ |segment| segment.to_sym }))
                unless setting_value.nil?
                    configuration_setting[:path] = config_path
                    configuration_setting[:value] = setting_value
                    module_configurations << configuration_setting
                end
            end
        end
        default[:magento_custom_modules][:module_list][module_key][:config_paths] = supported_custom_modules[module_key][:config_paths]
        default[:magento_custom_modules][:module_list][module_key][:configuration] = module_configurations
    end
end