#
# Cookbook:: custom_modules
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:custom_modules][:user] = node[:init][:os][:user]

include_attribute 'composer::default'
default[:custom_modules][:composer][:filename] = node[:composer][:file]

include_attribute 'nginx::default'
default[:custom_modules][:web_root] = node[:nginx][:web_root]