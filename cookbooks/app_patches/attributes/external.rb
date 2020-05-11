#
# Cookbook:: app_patches
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:app_patches][:user] = node[:init][:os][:user]

include_attribute "composer::default"
default[:app_patches][:composer_file] = node[:composer][:file]

include_attribute "nginx::default"
default[:app_patches][:web_root] = node[:nginx][:web_root]