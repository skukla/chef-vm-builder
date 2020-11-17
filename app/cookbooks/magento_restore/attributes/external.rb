#
# Cookbook:: magento_restore
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento_restore][:init][:user] = node[:init][:os][:user]
default[:magento_restore][:init][:web_root] = node[:init][:webserver][:web_root]