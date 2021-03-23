#
# Cookbook:: magento
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute 'magento::default'
include_attribute 'magento::override'
default[:magento_custom_modules][:magento][:build_action] = node[:magento][:build][:action]
