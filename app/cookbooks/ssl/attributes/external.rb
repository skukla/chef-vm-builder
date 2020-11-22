#
# Cookbook:: ssl
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute 'init::default'
include_attribute 'init::override'
default[:ssl][:init][:user] = node[:init][:os][:user]
default[:ssl][:init][:web_root] = node[:init][:webserver][:web_root]
default[:ssl][:init][:demo_structure] = node[:init][:custom_demo][:structure]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:ssl][:magento][:settings][:use_secure_frontend] = node[:magento][:settings][:use_secure_frontend]
default[:ssl][:magento][:settings][:use_secure_admin] = node[:magento][:settings][:use_secure_admin]
