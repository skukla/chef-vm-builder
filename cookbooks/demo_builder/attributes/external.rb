#
# Cookbook:: demo_builder
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:demo_builder][:user] = node[:init][:os][:user]

include_attribute "nginx::default"
include_attribute "nginx::override"
default[:demo_builder][:web_root] = node[:nginx][:web_root]

include_attribute "magento::default"
include_attribute "magento::override"
default[:demo_builder][:build][:action] = node[:magento][:installation][:build][:action]