#
# Cookbook:: magento_patches
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento_patches][:user] = node[:init][:os][:user]

include_attribute "composer::default"
default[:magento_patches][:composer_file] = node[:composer][:file]

include_attribute "nginx::default"
default[:magento_patches][:web_root] = node[:nginx][:web_root]