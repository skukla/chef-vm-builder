# Cookbook:: magento_custom_modules
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:magento_custom_modules][:magento][:build_action] = node[:magento][:build][:action]
