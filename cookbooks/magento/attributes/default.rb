#
# Cookbook:: magento
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:application][:installation][:conf_options] = 
{
    path: "general/store_information/name",
    value: node[:custom_demo][:configuration][:store_information][:data][:name],
    scope: node[:custom_demo][:configuration][:store_information][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:scope_code]
},
{
    path: "general/store_information/phone",
    value: node[:custom_demo][:configuration][:store_information][:data][:phone],
    scope: node[:custom_demo][:configuration][:store_information][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:scope_code]
},
{
    path: "general/store_information/hours",
    value: node[:custom_demo][:configuration][:store_information][:data][:hours],
    scope: node[:custom_demo][:configuration][:store_information][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:scope_code]
},
{
    path: "general/store_information/street_line1",
    value: node[:custom_demo][:configuration][:store_information][:data][:street_line1],
    scope: node[:custom_demo][:configuration][:store_information][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:scope_code]
},
{
    path: "general/store_information/street_line2",
    value: node[:custom_demo][:configuration][:store_information][:data][:street_line2],
    scope: node[:custom_demo][:configuration][:store_information][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:scope_code]
},
{
    path: "general/store_information/city",
    value: node[:custom_demo][:configuration][:store_information][:data][:city],
    scope: node[:custom_demo][:configuration][:store_information][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:scope_code]
},
{
    path: "general/store_information/region_id",
    value: node[:custom_demo][:configuration][:store_information][:data][:region_id],
    scope: node[:custom_demo][:configuration][:store_information][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:scope_code]
},
{
    path: "general/store_information/country_id",
    value: node[:custom_demo][:configuration][:store_information][:data][:country_id],
    scope: node[:custom_demo][:configuration][:store_information][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:scope_code]
},
{
    path: "general/store_information/postcode",
    value: node[:custom_demo][:configuration][:store_information][:data][:postcode],
    scope: node[:custom_demo][:configuration][:store_information][:scope],
    scope_code: node[:custom_demo][:configuration][:store_information][:scope_code]
},
{
    path: "catalog/product_video/youtube_api_key",
    value: "AIzaSyB-WIL0GOj7vNdC8vgx5cdkV7FDl7D9oYs",
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/related_position_limit",
    value: 5,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/related_position_behavior",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/related_rotation_mode",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/crosssell_position_limit",
    value: 6,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/crosssell_position_behavior",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/crosssell_rotation_mode",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/upsell_position_limit",
    value: 5,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/upsell_position_behavior",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/magento_targetrule/upsell_rotation_mode",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/enable_eav_indexer",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/engine",
    value: "elasticsearch6+",
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/elasticsearch6_server_hostname",
    value: "127.0.0.1",
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/elasticsearch6_server_port",
    value: node[:infrastructure][:elasticsearch][:port],
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/elasticsearch6_index_prefix",
    value: "magento2",
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/elasticsearch6_enable_auth",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "catalog/search/elasticsearch6_server_timeout",
    value: 15,
    scope: "default",
    scope_code: ""
},
{
    path: "sales/magento_rma/enabled",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "sales/magento_rma/enabled_on_product",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "sales/magento_rma/use_store_address",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "customer/password/required_character_classes_number",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "customer/password/lockout_failures",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "customer/password/minimum_password_length",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "shipping/origin/street_line1",
    value: node[:custom_demo][:configuration][:shipping][:origin][:data][:street_line1],
    scope: node[:custom_demo][:configuration][:shipping][:origin][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:scope_code]
},
{
    path: "shipping/origin/street_line2",
    value: node[:custom_demo][:configuration][:shipping][:origin][:data][:street_line2],
    scope: node[:custom_demo][:configuration][:shipping][:origin][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:scope_code]
},
{
    path: "shipping/origin/city",
    value: node[:custom_demo][:configuration][:shipping][:origin][:data][:city],
    scope: node[:custom_demo][:configuration][:shipping][:origin][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:scope_code]
},
{
    path: "shipping/origin/region_id",
    value: node[:custom_demo][:configuration][:shipping][:origin][:data][:region_id],
    scope: node[:custom_demo][:configuration][:shipping][:origin][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:scope_code]
},
{
    path: "shipping/origin/country_id",
    value: node[:custom_demo][:configuration][:shipping][:origin][:data][:country_id],
    scope: node[:custom_demo][:configuration][:shipping][:origin][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:scope_code]
},
{
    path: "shipping/origin/postcode",
    value: node[:custom_demo][:configuration][:shipping][:origin][:data][:postcode],
    scope: node[:custom_demo][:configuration][:shipping][:origin][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:origin][:scope_code]
},
{
    path: "carriers/ups/active",
    value: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:enable],
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/active_rma",
    value: 1,
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/type",
    value: "UPS_XML",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/mode_xml",
    value: 0,
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/username",
    value: "magento",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/password",
    value: "magento200",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/access_license_number",
    value: "ECAB751ABF189ECA",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/shipper_number",
    value: "207W88",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/allowed_methods",
    value: "01,03",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/free_shipping_enable",
    value: 1,
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/free_method",
    value: "03",
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/ups/free_shipping_subtotal",
    value: 1000000000,
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:ups][:scope_code]
},
{
    path: "carriers/flatrate/active",
    value: node[:custom_demo][:configuration][:shipping][:carriers][:flatrate][:enable],
    scope: node[:custom_demo][:configuration][:shipping][:carriers][:flatrate][:scope],
    scope_code: node[:custom_demo][:configuration][:shipping][:carriers][:flatrate][:scope_code]
},
{
    path: "payment/braintree/active",
    value: node[:custom_demo][:configuration][:payment][:braintree][:enable],
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/title",
    value: "Credit Card",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/environment",
    value: "sandbox",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/payment_action",
    value: node[:custom_demo][:configuration][:payment][:braintree][:payment_action],
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/merchant_account_id",
    value: "magento",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/merchant_id",
    value: "zkw2ctrkj75ndvkc",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/public_key",
    value: "n2bt4844t6xrt56x",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/private_key",
    value: "e6c98fd99fe699d4169475fef026d5b9",
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/debug",
    value: 0,
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree_cc_vault/active",
    value: 1,
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/cctypes",
    value: node[:custom_demo][:configuration][:payment][:braintree][:cctypes],
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "payment/braintree/useccv",
    value: 1,
    scope: node[:custom_demo][:configuration][:payment][:braintree][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:braintree][:scope_code]
},
{
    path: "paypal/general/merchant_country",
    value: node[:custom_demo][:configuration][:payment][:paypal][:merchant_country],
    scope: node[:custom_demo][:configuration][:payment][:paypal][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:paypal][:scope_code]
},
{
    path: "payment/braintree_paypal/active",
    value: node[:custom_demo][:configuration][:payment][:paypal][:enable],
    scope: node[:custom_demo][:configuration][:payment][:paypal][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:paypal][:scope_code]
},
{
    path: "payment/braintree_paypal/title",
    value: "PayPal",
    scope: node[:custom_demo][:configuration][:payment][:paypal][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:paypal][:scope_code]
},
{
    path: "payment/braintree_paypal_vault/active",
    value: 1,
    scope: node[:custom_demo][:configuration][:payment][:paypal][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:paypal][:scope_code]
},
{
    path: "payment/braintree_paypal/payment_action",
    value: node[:custom_demo][:configuration][:payment][:paypal][:payment_action],
    scope: node[:custom_demo][:configuration][:payment][:paypal][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:paypal][:scope_code]
},
{
    path: "payment/checkmo/active",
    value: node[:custom_demo][:configuration][:payment][:checkmo][:enable],
    scope: node[:custom_demo][:configuration][:payment][:checkmo][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:checkmo][:scope_code]
},
{
    path: "payment/companycredit/active",
    value: node[:custom_demo][:configuration][:payment][:companycredit][:enable],
    scope: node[:custom_demo][:configuration][:payment][:companycredit][:scope],
    scope_code: node[:custom_demo][:configuration][:payment][:companycredit][:scope_code]
},
{
    path: "admin/security/admin_account_sharing",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "admin/security/session_lifetime",
    value: 900000,
    scope: "default",
    scope_code: ""
},
{
    path: "admin/security/use_case_sensitive_login",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "admin/security/password_is_forced",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "admin/security/max_number_password_reset_requests",
    value: 0,
    scope: "default",
    scope_code: ""
},
{
    path: "admin/dashboard/enable_charts",
    value: 1,
    scope: "default",
    scope_code: ""
},
{
    path: "btob/website_configuration/company_active",
    value: node[:custom_demo][:configuration][:b2b][:companies][:enable],
    scope: node[:custom_demo][:configuration][:b2b][:companies][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:companies][:scope_code]
},
{
    path: "btob/website_configuration/negotiablequote_active",
    value: node[:custom_demo][:configuration][:b2b][:quotes][:enable],
    scope: node[:custom_demo][:configuration][:b2b][:quotes][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:quotes][:scope_code]
},
{
    path: "btob/website_configuration/quickorder_active",
    value: node[:custom_demo][:configuration][:b2b][:quick_order][:enable],
    scope: node[:custom_demo][:configuration][:b2b][:quick_order][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:quick_order][:scope_code]
},
{
    path: "btob/website_configuration/requisition_list_active",
    value: node[:custom_demo][:configuration][:b2b][:requisition_lists][:enable],
    scope: node[:custom_demo][:configuration][:b2b][:requisition_lists][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:requisition_lists][:scope_code]
},
{
    path: "btob/website_configuration/sharedcatalog_active",
    value: node[:custom_demo][:configuration][:b2b][:shared_catalogs][:enable],
    scope: node[:custom_demo][:configuration][:b2b][:shared_catalogs][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:shared_catalogs][:scope_code]
},
{
    path: "btob/default_b2b_payment_methods/applicable_payment_methods",
    value: 1,
    scope: "website",
    scope_code: "base"
},
{
    path: "btob/default_b2b_payment_methods/available_payment_methods",
    value: node[:custom_demo][:configuration][:b2b][:payment_methods][:data],
    scope: node[:custom_demo][:configuration][:b2b][:payment_methods][:scope],
    scope_code: node[:custom_demo][:configuration][:b2b][:payment_methods][:scope_code]
}


default[:custom_demo][:custom_modules][:conf_options] = {
    path: "magentoese_autofill/general/enable_autofill",
    value: node[:custom_demo][:configuration][:autofill][:enable]
},
{
    path: "magentoese_autofill/persona_1/enable",
    value: node[:custom_demo][:configuration][:autofill][:enable]
},
{
    path: "magentoese_autofill/persona_1/label",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:label]
},
{
    path: "magentoese_autofill/persona_1/email_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:email]
},
{
    path: "magentoese_autofill/persona_1/password_value",   
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:password]
},
{
    path: "magentoese_autofill/persona_1/firstname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:firstname]
},
{
    path: "magentoese_autofill/persona_1/lastname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:lastname],
},
{
    path: "magentoese_autofill/persona_1/address_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:address]
},
{
    path: "magentoese_autofill/persona_1/city_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:city]
},
{
    path: "magentoese_autofill/persona_1/state_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:state]
},
{
    path: "magentoese_autofill/persona_1/zip_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:zip]
},
{
    path: "magentoese_autofill/persona_1/country_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:country]
},
{
    path: "magentoese_autofill/persona_1/telephone_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:telephone]
},
{
    path: "magentoese_autofill/persona_1/company_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_1][:company]
},
{
    path: "magentoese_autofill/persona_2/enable",
    value: node[:custom_demo][:configuration][:autofill][:enable]
},
{
    path: "magentoese_autofill/persona_2/label",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:label]
},
{
    path: "magentoese_autofill/persona_2/email_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:email]
},
{
    path: "magentoese_autofill/persona_2/password_value",   
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:password]
},
{
    path: "magentoese_autofill/persona_2/firstname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:firstname],
},
{
    path: "magentoese_autofill/persona_2/lastname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:lastname]
},
{
    path: "magentoese_autofill/persona_2/address_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:address]
},
{
    path: "magentoese_autofill/persona_2/city_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:city]
},
{
    path: "magentoese_autofill/persona_2/state_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:state]
},
{
    path: "magentoese_autofill/persona_2/zip_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:zip]
},
{
    path: "magentoese_autofill/persona_2/country_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:country]
},
{
    path: "magentoese_autofill/persona_2/telephone_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:telephone]
},
{
    path: "magentoese_autofill/persona_2/company_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_2][:company]
},
{
    path: "magentoese_autofill/persona_3/enable",
    value: node[:custom_demo][:configuration][:autofill][:enable]
},
{
    path: "magentoese_autofill/persona_3/label",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:label]
},
{
    path: "magentoese_autofill/persona_3/email_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:email]
},
{
    path: "magentoese_autofill/persona_3/password_value",   
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:password],
},
{
    path: "magentoese_autofill/persona_3/firstname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:firstname]
},
{
    path: "magentoese_autofill/persona_3/lastname_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:lastname],
},
{
    path: "magentoese_autofill/persona_3/address_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:address],
},
{
    path: "magentoese_autofill/persona_3/city_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:city]
},
{
    path: "magentoese_autofill/persona_3/state_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:state]
},
{
    path: "magentoese_autofill/persona_3/zip_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:zip]
},
{
    path: "magentoese_autofill/persona_3/country_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:country]
},
{
    path: "magentoese_autofill/persona_3/telephone_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:telephone]
},
{
    path: "magentoese_autofill/persona_3/company_value",
    value: node[:custom_demo][:configuration][:autofill][:persona_3][:company]
}
