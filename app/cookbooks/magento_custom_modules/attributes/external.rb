#
# Cookbook:: magento_custom_modules
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute 'elasticsearch::default'
default[:magento_custom_modules][:elasticsearch][:use] = node[:elasticsearch][:use]
