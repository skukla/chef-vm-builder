#
# Cookbook:: magento_custom_modules
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento_custom_modules][:user] = node[:init][:os][:user]

include_attribute 'composer::default'
default[:magento_custom_modules][:composer][:file] = node[:composer][:file]

include_attribute 'nginx::default'
default[:magento_custom_modules][:web_root] = node[:nginx][:web_root]

include_attribute 'elasticsearch::default'
default[:magento_custom_modules][:use_elasticsearch] = node[:elasticsearch][:use]