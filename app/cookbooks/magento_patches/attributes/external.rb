#
# Cookbook:: magento_patches
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute 'init::default'
default[:magento_patches][:init][:user] = node[:init][:os][:user]
default[:magento_patches][:init][:web_root] = node[:init][:webserver][:web_root]

include_attribute 'composer::default'
default[:magento_patches][:composer][:file] = node[:composer][:file]

include_attribute 'magento::default'
default[:magento_patches][:magento][:version] = node[:magento][:options][:version]
default[:magento_patches][:magento][:sample_data] = node[:magento][:build][:sample_data]
