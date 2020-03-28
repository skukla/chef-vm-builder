#
# Cookbook:: magento
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:application][:installation][:conf_options] = 
{
    path: "general/store_information/name",
    value: "Suez North America"
},
{
    path: "general/store_information/phone",
    value: "1 (877) 219-5520"
},
{
    path: "general/store_information/hours",
    value: "9AM - 5PM"
},
{
    path: "general/store_information/street_line1",
    value: "461 From Road"
},
{
    path: "general/store_information/street_line2",
    value: "Suite 400"
},
{
    path: "general/store_information/region_id",
    value: 41
},
{
    path: "general/store_information/country_id",
    value: "US"
},
{
    path: "general/store_information/city",
    value: "Paramus"
},
{
    path: "general/store_information/postcode",
    value: 07652
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
    value: "elasticsuite"
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
    value: "461 From Road"
},
{
    path: "shipping/origin/street_line2",
    value: "Suite 400"
},
{
    path: "shipping/origin/city",
    value: "Paramus"
},
{
    path: "shipping/origin/postcode",
    value: 07652
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
}

default[:application][:installation][:custom_modules][:conf_options] = {
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
    value: "Suez North America"
}
