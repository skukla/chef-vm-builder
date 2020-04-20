#
# Cookbook:: app_configuration
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:application][:installation][:default_configuration] =
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