#
# Cookbook:: magento
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:application][:installation][:conf_options] = 
{
    path: "general/store_information/name",
    value: "Luma, Inc."
},
{
    path: "general/store_information/phone",
    value: "1-310-945-0345"
},
{
    path: "general/store_information/hours",
    value: "9AM - 5PM"
},
{
    path: "general/store_information/street_line1",
    value: "3640 Holdrege Ave"
},
{
    path: "general/store_information/street_line2",
    value: ""
},
{
    path: "general/store_information/city",
    value: "Los Angeles"
},
{
    path: "general/store_information/region_id",
    value: 12
},
{
    path: "general/store_information/country_id",
    value: "US"
},
{
    path: "general/store_information/postcode",
    value: 90016
},
{
    path: "catalog/product_video/youtube_api_key",
    value: "AIzaSyB-WIL0GOj7vNdC8vgx5cdkV7FDl7D9oYs"
},
{
    path: "catalog/magento_targetrule/related_position_limit",
    value: 5
},
{
    path: "catalog/magento_targetrule/related_position_behavior",
    value: 0
},
{
    path: "catalog/magento_targetrule/related_rotation_mode",
    value: 0
},
{
    path: "catalog/magento_targetrule/crosssell_position_limit",
    value: 6
},
{
    path: "catalog/magento_targetrule/crosssell_position_behavior",
    value: 0
},
{
    path: "catalog/magento_targetrule/crosssell_rotation_mode",
    value: 0
},
{
    path: "catalog/magento_targetrule/upsell_position_limit",
    value: 5
},
{
    path: "catalog/magento_targetrule/upsell_position_behavior",
    value: 0
},
{
    path: "catalog/magento_targetrule/upsell_rotation_mode",
    value: 0
},
{
    path: "catalog/search/enable_eav_indexer",
    value: 1
},
{
    path: "catalog/search/engine",
    value: "elasticsearch6+"
},
{
    path: "catalog/search/elasticsearch6_server_hostname",
    value: "127.0.0.1"
},
{
    path: "catalog/search/elasticsearch6_server_port",
    value: node[:infrastructure][:elasticsearch][:port]
},
{
    path: "catalog/search/elasticsearch6_index_prefix",
    value: "magento2"
},
{
    path: "catalog/search/elasticsearch6_enable_auth",
    value: 0
},
{
    path: "catalog/search/elasticsearch6_server_timeout",
    value: 15
},
{
    path: "sales/magento_rma/enabled",
    value: 1
},
{
    path: "sales/magento_rma/enabled_on_product",
    value: 1
},
{
    path: "sales/magento_rma/use_store_address",
    value: 1
},
{
    path: "customer/password/required_character_classes_number",
    value: 1
},
{
    path: "customer/password/lockout_failures",
    value: 0
},
{
    path: "customer/password/minimum_password_length",
    value: 1
},
{
    path: "shipping/origin/street_line1",
    value: "3640 Holdrege Ave"
},
{
    path: "shipping/origin/street_line2",
    value: ""
},
{
    path: "shipping/origin/city",
    value: "Los Angeles"
},
{
    path: "shipping/origin/region_id",
    value: 12
},
{
    path: "shipping/origin/postcode",
    value: 90016
},
{
    path: "carriers/ups/active",
    value: 1
},
{
    path: "carriers/ups/active_rma",
    value: 1
},
{
    path: "carriers/ups/type",
    value: "UPS_XML"
},
{
    path: "carriers/ups/mode_xml",
    value: 0
},
{
    path: "carriers/ups/username",
    value: "magento"
},
{
    path: "carriers/ups/password",
    value: "magento200"
},
{
    path: "carriers/ups/access_license_number",
    value: "ECAB751ABF189ECA"
},
{
    path: "carriers/ups/shipper_number",
    value: "207W88"
},
{
    path: "carriers/ups/allowed_methods",
    value: "01,03"
},
{
    path: "carriers/ups/free_shipping_enable",
    value: 1
},
{
    path: "carriers/ups/free_method",
    value: "03"
},
{
    path: "carriers/ups/free_shipping_subtotal",
    value: 1000000000
},
{
    path: "payment/braintree/active",
    value: 1
},
{
    path: "payment/braintree/title",
    value: "Credit Card"
},
{
    path: "payment/braintree/environment",
    value: "sandbox"
},
{
    path: "payment/braintree/payment_action",
    value: "authorize"
},
{
    path: "payment/braintree/merchant_account_id",
    value: "magento"
},
{
    path: "payment/braintree/merchant_id",
    value: "zkw2ctrkj75ndvkc"
},
{
    path: "payment/braintree/public_key",
    value: "n2bt4844t6xrt56x"
},
{
    path: "payment/braintree/private_key",
    value: "e6c98fd99fe699d4169475fef026d5b9"
},
{
    path: "payment/braintree/debug",
    value: 0
},
{
    path: "payment/braintree_cc_vault/active",
    value: 1
},
{
    path: "payment/braintree/cctypes",
    value: "AE,VI,MC,DI,JCB"
},
{
    path: "payment/braintree/useccv",
    value: 1
},
{
    path: "paypal/general/merchant_country",
    value: "US",
    scope: "website",
    scope_code: "base"
},
{
    path: "payment/braintree_paypal/active",
    value: 1
},
{
    path: "payment/braintree_paypal/title",
    value: "PayPal"
},
{
    path: "payment/braintree_paypal_vault/active",
    value: 1
},
{
    path: "payment/braintree_paypal/payment_action",
    value: "authorize"
},
{
    path: "admin/security/admin_account_sharing",
    value: 1
},
{
    path: "admin/security/session_lifetime",
    value: 900000
},
{
    path: "admin/security/use_case_sensitive_login",
    value: 0
},
{
    path: "admin/security/password_is_forced",
    value: 0
},
{
    path: "admin/security/max_number_password_reset_requests",
    value: 0
},
{
    path: "admin/dashboard/enable_charts",
    value: 1
},
{
    path: "admin/captcha/enable",
    value: 0
},
{
    path: "btob/website_configuration/company_active",
    value: 1,
    scope: "website",
    scope_code: "base"
},
{
    path: "btob/website_configuration/sharedcatalog_active",
    value: 0,
    scope: "website",
    scope_code: "base"
},
{
    path: "btob/website_configuration/negotiablequote_active",
    value: 1,
    scope: "website",
    scope_code: "base"
},
{
    path: "btob/website_configuration/quickorder_active",
    value: 1,
    scope: "website",
    scope_code: "base"
},
{
    path: "btob/website_configuration/requisition_list_active",
    value: 1,
    scope: "website",
    scope_code: "base"
},
{
    path: "btob/default_b2b_payment_methods/applicable_payment_methods",
    value: 1,
    scope: "website",
    scope_code: "base"
},
{
    path: "btob/default_b2b_payment_methods/available_payment_methods",
    value: "companycredit",
    scope: "website",
    scope_code: "base"
},
{
    path: "payment/companycredit/active",
    value: 1,
    scope: "website",
    scope_code: "base"
}


default[:custom_demo][:custom_modules][:conf_options] = {
    path: "magentoese_autofill/general/enable_autofill",
    value: 1
},
{
    path: "magentoese_autofill/persona_1/enable",
    value: 1
},
{
    path: "magentoese_autofill/persona_1/label",
    value: "Steve Kukla"
},
{
    path: "magentoese_autofill/persona_1/email_value",
    value: "steve@example.com"
},
{
    path: "magentoese_autofill/persona_1/password_value",   
    value: "Password1"
},
{
    path: "magentoese_autofill/persona_1/firstname_value",
    value: "Steve"
},
{
    path: "magentoese_autofill/persona_1/lastname_value",
    value: "Kukla"
},
{
    path: "magentoese_autofill/persona_1/company_value",
    value: "Luma, Inc."
},
{
    path: "magentoese_autofill/persona_1/address_value",
    value: "3640 Holdrege Ave"
},
{
    path: "magentoese_autofill/persona_1/country_value",
    value: "US"
},
{
    path: "magentoese_autofill/persona_1/state_value",
    value: 12
},
{
    path: "magentoese_autofill/persona_1/city_value",
    value: "Los Angeles"
},
{
    path: "magentoese_autofill/persona_1/zip_value",
    value: 90016
},
{
    path: "magentoese_autofill/persona_1/telephone_value",
    value: "310-945-0345"
}
