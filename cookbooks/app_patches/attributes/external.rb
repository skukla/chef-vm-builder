#
# Cookbook:: app_patches
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:app_patches][:user] = node[:init][:user]

include_attribute "composer::default"
default[:app_patches][:composer_filename] = node[:composer][:filename]

include_attribute "magento::default"
default[:app_patches][:web_root] = node[:magento][:installation][:options][:directory]