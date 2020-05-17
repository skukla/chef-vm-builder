#
# Cookbook:: magento_configuration
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# It's unusual to use external attributes inside default attribute files, so we make sure they're included...
include_attribute "magento_configuration::external"
default[:magento_configuration][:paths] = [
    "admin/security/admin_account_sharing",
    "admin/security/max_number_password_reset_requests",
    "admin/security/password_is_forced",
    "admin/security/session_lifetime",
    "admin/security/use_case_sensitive_login",
    "admin/dashboard/enable_charts",
    "admin/usage/enabled",
    "analytics/subscription/enabled",
    "btob/website_configuration/company_active",
    "btob/website_configuration/negotiablequote_active",
    "btob/website_configuration/quickorder_active",
    "btob/website_configuration/requisition_list_active",
    "btob/website_configuration/sharedcatalog_active",
    "carriers/dhl/active_rma",
    "carriers/dhl/free_method_nondoc",
    "carriers/dhl/free_shipping_enable",
    "carriers/dhl/debug",
    "carriers/dhl/handling_fee",
    "carriers/dhl/id",
    "carriers/dhl/password",
    "carriers/dhl/sandbox_mode",
    "carriers/dhl/showmethod",
    "carriers/dhl/sort_order",
    "carriers/dhl/specificcountry",
    "carriers/fedex/account",
    "carriers/fedex/active_rma",
    "carriers/fedex/free_shipping_enable",
    "carriers/fedex/debug",
    "carriers/fedex/handling_fee",
    "carriers/fedex/key",
    "carriers/fedex/meter_number",
    "carriers/fedex/password",
    "carriers/fedex/residence_delivery",
    "carriers/fedex/showmethod",
    "carriers/fedex/smartpost_hubid",
    "carriers/fedex/sort_order",
    "carriers/fedex/specificcountry",
    "carriers/flatrate/active",
    "carriers/flatrate/handling_fee",
    "carriers/flatrate/showmethod",
    "carriers/flatrate/sort_order",
    "carriers/flatrate/specificcountry",
    "carriers/freeshipping/free_shipping_subtotal",
    "carriers/freeshipping/showmethod",
    "carriers/freeshipping/sort_order",
    "carriers/freeshipping/specificcountry",
    "carriers/tablerate/active",
    "carriers/tablerate/condition_name",
    "carriers/tablerate/handling_fee",
    "carriers/tablerate/showmethod",
    "carriers/tablerate/sort_order",
    "carriers/tablerate/specificcountry",
    "carriers/ups/active_rma",
    "carriers/ups/free_shipping_enable",
    "carriers/ups/debug",
    "carriers/ups/handling_fee",
    "carriers/ups/shipper_number",
    "carriers/ups/showmethod",
    "carriers/ups/sort_order",
    "carriers/ups/specificcountry",
    "carriers/usps/active_rma",
    "carriers/usps/free_shipping_enable",
    "carriers/usps/debug",
    "carriers/usps/handling_fee",
    "carriers/usps/password",
    "carriers/usps/showmethod",
    "carriers/usps/sort_order",
    "carriers/usps/specificcountry",
    "carriers/usps/userid",
    "catalog/category/root_id",
    "catalog/magento_targetrule/crosssell_position_behavior",
    "catalog/magento_targetrule/crosssell_position_limit",
    "catalog/magento_targetrule/crosssell_rotation_mode",
    "catalog/magento_targetrule/related_position_behavior",
    "catalog/magento_targetrule/related_position_limit",
    "catalog/magento_targetrule/related_rotation_mode",
    "catalog/magento_targetrule/upsell_position_behavior",
    "catalog/magento_targetrule/upsell_position_limit",
    "catalog/magento_targetrule/upsell_rotation_mode",
    "catalog/product_video/youtube_api_key",
    "catalog/search/enable_eav_indexer",
    "catalog/search/engine",
    "catalog/search/elasticsearch6_enable_auth",
    "catalog/search/elasticsearch6_server_hostname",
    "catalog/search/elasticsearch6_server_port",
    "catalog/search/elasticsearch6_server_timeout",
    "catalog/search/elasticsearch6_index_prefix",
    "connector_automation/review_settings/allow_non_subscribers",
    "connector_configuration/abandoned_carts/allow_non_subscribers",
    "connector_dynamic_content/external_dynamic_content_urls/passcode",
    "crontab/default/jobs/analytics_collect_data/schedule/cron_expr",
    "crontab/default/jobs/analytics_subscribe/schedule/cron_expr",
    "currency/options/allow",
    "currency/options/base",
    "currency/options/default",
    "customer/password/lockout_failures",
    "customer/password/minimum_password_length",
    "customer/password/required_character_classes_number",
    "customer/startup/redirect_dashboard",
    "design/theme/theme_id",
    "design/head/includes",
    "design/header/welcome",
    "general/locale/code",
    "general/locale/timezone",
    "general/region/display_all",
    "general/region/state_required",
    "general/restriction/cms_page" ,
    "general/restriction/http_redirect",
    "general/restriction/is_active",
    "general/restriction/mode",
    "general/store_information/city",
    "general/store_information/country_id",
    "general/store_information/hours",
    "general/store_information/name",
    "general/store_information/phone",
    "general/store_information/postcode",
    "general/store_information/region_id",
    "general/store_information/street_line1",
    "general/store_information/street_line2",
    "msp_securitysuite_twofactorauth/duo/application_key",
    "sales/magento_rma/enabled",
    "sales/magento_rma/enabled_on_product",
    "sales/magento_rma/use_store_address",
    "sales/msrp/enabled",
    "shipping/origin/city",
    "shipping/origin/country_id",
    "shipping/origin/postcode",
    "shipping/origin/region_id",
    "shipping/origin/street_line1",
    "shipping/origin/street_line2",
    "payment/authorizenet_acceptjs/cctypes",
    "payment/authorizenet_acceptjs/currency",
    "payment/authorizenet_acceptjs/order_status",
    "payment/authorizenet_acceptjs/payment_action",
    "payment/braintree/active",
    "payment/braintree/cctypes",
    "payment/braintree/debug",
    "payment/braintree/environment",
    "payment/braintree/merchant_account_id",
    "payment/braintree/merchant_id",
    "payment/braintree/payment_action",
    "payment/braintree/private_key",
    "payment/braintree/public_key",
    "payment/braintree/title",
    "payment/braintree/useccv",
    "payment/braintree_cc_vault/active",
    "payment/braintree_paypal/active",
    "payment/braintree_paypal/payment_action",
    "payment/braintree_paypal/title",
    "payment/braintree_paypal_vault/active",
    "payment/checkmo/active",
    "payment/companycredit/active",
    "sync_settings/addressbook/allow_non_subscribers",
    "web/secure/base_url",
    "web/secure/use_in_frontend",
    "web/secure/use_in_adminhtml",
    "web/seo/use_rewrites",
    "web/unsecure/base_url",
    "wishlist/general/multiple_enabled",
    "yotpo/module_info/yotpo_installation_date",
    "yotpo/sync_settings/orders_sync_start_date"
]
default[:magento_configuration][:settings][:defaults] =
{
    admin: {
        dashboard: {
            enable_charts: 0
        },
        security: {
            session_lifetime: 900000,
            use_case_sensitive_login: 0,
            password_is_forced: 0,
            max_number_password_reset_requests: 0
        },
    },
    analytics: {
        subscription: {
            enabled: 0
        }
    },
    carriers: {
        flatrate: {
            active: false
        }
    },
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
        }
    },
    customer: {
        password: {
            required_character_classes_number: 1,
            lockout_failures: 0,
            minimum_password_length: 1
        }
    },
    payment: {
        checkmo: {
            active: 1
        }
    },
    sales: {
        magento_rma: {
            enabled: 1,
            enabled_on_product: 1,
            use_store_address: 1
        }
    }
}
default[:magento_configuration][:flags][:base] = false
default[:magento_configuration][:flags][:b2b] = false
default[:magento_configuration][:flags][:custom_modules] = false
default[:magento_configuration][:flags][:admin_users] = false