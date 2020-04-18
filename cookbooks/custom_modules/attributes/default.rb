#
# Cookbook:: app_configuration
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Cookbook:: configuration
# Attribute:: custom_module_config_paths
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

autofill_fields = [
    'enable', 
    'label',
    'email_value', 
    'password_value', 
    'firstname_value', 
    'lastname_value', 
    'address_value', 
    'city_value', 
    'state_value', 
    'zip_value', 
    'country_value', 
    'telephone_value', 
    'company_value'
]

default[:custom_demo][:module_autofill][:config_paths] = Array.new
default[:custom_demo][:elasticsuite][:config_paths] = Array.new

# Autofill
default[:custom_demo][:module_autofill][:config_paths] << "magentoese_autofill/general/enable_autofill"
[*1..17].each do |i|
    autofill_fields.each_with_index do |field, index|
        default[:custom_demo][:module_autofill][:config_paths] << "magentoese_autofill/persona_#{i}/#{field}"
    end
end

default[:custom_demo][:elasticsuite][:config_paths] << "catalog/search/engine"