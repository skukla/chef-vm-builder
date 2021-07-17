# Cookbook:: magento
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'magento::commerce_services_override'
include_attribute 'magento::application_options_override'
include_attribute 'magento::build_options_override'
include_attribute 'magento::build_hooks_override'
include_attribute 'magento::installation_settings_override'
