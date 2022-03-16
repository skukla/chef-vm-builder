# Cookbook:: magento
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'magento::override_commerce_services'
include_attribute 'magento::override_application_options'
include_attribute 'magento::override_build_options'
include_attribute 'magento::override_build_hooks'
include_attribute 'magento::override_installation_settings'
