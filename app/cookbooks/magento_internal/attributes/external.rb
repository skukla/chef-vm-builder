#
# Cookbook:: magento_internal
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento_internal][:init][:user] = node[:init][:os][:user]

include_attribute "magento_patches::default"
default[:magento_internal][:patches][:repository_url] = node[:magento_patches][:repository_url]
default[:magento_internal][:patches][:holding_area] = node[:magento_patches][:holding_area]

include_attribute "magento::default"
default[:magento_internal][:magento][:version] = node[:magento][:installation][:options][:version]