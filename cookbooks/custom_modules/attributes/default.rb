#
# Cookbook:: custom_modules
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
autofill_fields = [
    :enable, 
    :label, 
    :email_value, 
    :password_value, 
    :firstname_value,
    :lastname_value,
    :address_value,
    :city_value,
    :state_value,
    :zip_value,
    :country_value,
    :telephone_value,
    :company_value
]
default[:custom_modules][:module_autofill][:config_paths] = ["magentoese_autofill/general/enable_autofill"]
[*1..17].each do |i|
    autofill_fields.each_with_index do |field, index|
        default[:custom_modules][:module_autofill][:config_paths] << "magentoese_autofill/persona_#{i}/#{field}"
    end
end
default[:custom_modules][:module_autofill][:configuration] = {
    magentoese_autofill: {
        general: {
            enable_autofill: 1
        }
    }
}
default[:custom_modules][:elasticsuite][:config_paths] = ["catalog/search/engine"]
default[:custom_modules][:elasticsuite][:configuration] = {
    catalog: {
        search: {
            engine: "elasticsuite"
        }
    }
}