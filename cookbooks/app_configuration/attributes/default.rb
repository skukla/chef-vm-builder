#
# Cookbook:: app_configuration
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# It's unusual to use external attributes inside default attribute files, so we make sure they're included...
include_attribute "app_configuration::external"
default[:app_configuration][:configuration_paths] = [
    "general/restriction/is_active",
    "general/restriction/mode",
    "general/restriction/http_redirect",
    "general/restriction/cms_page" ,
    "general/store_information/name",
    "general/store_information/phone",
    "general/store_information/hours",
    "general/store_information/street_line1",
    "general/store_information/street_line2",
    "general/store_information/city",
    "general/store_information/region_id",
    "general/store_information/postcode",
    "general/store_information/country_id",
    "btob/website_configuration/company_active",
    "btob/website_configuration/negotiablequote_active",
    "btob/website_configuration/quickorder_active",
    "btob/website_configuration/requisition_list_active",
    "btob/website_configuration/sharedcatalog_active",
    "catalog/product_video/youtube_api_key",
    "catalog/magento_targetrule/related_position_limit",
    "catalog/magento_targetrule/related_position_behavior",
    "catalog/magento_targetrule/related_rotation_mode",
    "catalog/magento_targetrule/crosssell_position_limit",
    "catalog/magento_targetrule/crosssell_position_behavior",
    "catalog/magento_targetrule/crosssell_rotation_mode",
    "catalog/magento_targetrule/upsell_position_limit",
    "catalog/magento_targetrule/upsell_position_behavior",
    "catalog/magento_targetrule/upsell_rotation_mode",
    "catalog/search/enable_eav_indexer",
    "catalog/search/engine",
    "catalog/search/elasticsearch6_server_hostname",
    "catalog/search/elasticsearch6_server_port",
    "catalog/search/elasticsearch6_index_prefix",
    "catalog/search/elasticsearch6_enable_auth",
    "catalog/search/elasticsearch6_server_timeout",
    "customer/startup/redirect_dashboard",
    "sales/magento_rma/enabled",
    "sales/magento_rma/enabled_on_product",
    "sales/magento_rma/use_store_address",
    "customer/password/required_character_classes_number",
    "customer/password/lockout_failures",
    "customer/password/minimum_password_length",
    "shipping/origin/street_line1",
    "shipping/origin/street_line2",
    "shipping/origin/city",
    "shipping/origin/region_id",
    "shipping/origin/postcode",
    "shipping/origin/country_id",
    "carriers/ups/active",
    "carriers/ups/active_rma",
    "carriers/ups/type",
    "carriers/ups/mode_xml",
    "carriers/ups/username",
    "carriers/ups/password",
    "carriers/ups/access_license_number",
    "carriers/ups/shipper_number",
    "carriers/ups/allowed_methods",
    "carriers/ups/free_shipping_enable",
    "carriers/ups/free_method",
    "carriers/ups/free_shipping_subtotal",
    "carriers/flatrate/active",
    "payment/braintree/active",
    "payment/braintree/title",
    "payment/braintree/environment",
    "payment/braintree/payment_action",
    "payment/braintree/merchant_account_id",
    "payment/braintree/merchant_id",
    "payment/braintree/public_key",
    "payment/braintree/private_key",
    "payment/braintree/cctypes",
    "payment/braintree/debug",
    "payment/braintree_cc_vault/active",
    "payment/braintree/useccv",
    "payment/braintree_paypal/active",
    "payment/braintree_paypal/payment_action",
    "payment/braintree_paypal/title",
    "payment/braintree_paypal_vault/active",
    "payment/checkmo/active",
    "payment/companycredit/active",
    "admin/security/admin_account_sharing",
    "admin/security/session_lifetime",
    "admin/security/use_case_sensitive_login",
    "admin/security/password_is_forced",
    "admin/security/max_number_password_reset_requests",
    "admin/dashboard/enable_charts"
]
default[:app_configuration][:configuration] =
{
    catalog: {
        magento_targetrule: {
            related_position_limit: 5,
            related_position_behavior: 0,
            related_rotation_mode: 0,
            crosssell_position_limit: 6,
            crosssell_position_behavior: 0,
            crosssell_rotation_mode: 0,
            upsell_position_limit: 5,
            upsell_position_behavior: 0,
            upsell_rotation_mode: 0
        },
        search: {
            enable_eav_indexer: 1,
            engine: "elasticsearch6",
            elasticsearch6_server_hostname: "127.0.0.1",
            elasticsearch6_server_port: node[:app_configuration][:elasticsearch_port],
            elasticsearch6_index_prefix: "magento2",
            elasticsearch6_enable_auth: 0,
            elasticsearch6_server_timeout: 15
        }
    },
    sales: {
        magento_rma: {
            enabled: 1,
            enabled_on_product: 1,
            use_store_address: 1
        }
    },
    customer: {
        password: {
            required_character_classes_number: 1,
            lockout_failures: 0,
            minimum_password_length: 1
        }
    },
    carriers: {
        flatrate: {
            active: false
        }
    },
    payment: {
        checkmo: {
            active: 1
        }
    },
    admin: {
        dashboard: {
            enable_charts: 0
        },
        security: {
            session_lifetime: 900000,
            use_case_sensitive_login: 0,
            password_is_forced: 0,
            max_number_password_reset_requests: 0
        }
    }
}