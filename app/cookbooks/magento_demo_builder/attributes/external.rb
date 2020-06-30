#
# Cookbook:: magento_demo_builder
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento_demo_builder][:user] = node[:init][:os][:user]

include_attribute "mysql::default"
default[:magento_demo_builder][:database][:user] = node[:mysql][:db_user]
default[:magento_demo_builder][:database][:password] = node[:mysql][:db_password]
default[:magento_demo_builder][:database][:name] = node[:mysql][:db_name]

include_attribute "nginx::default"
include_attribute "nginx::override"
default[:magento_demo_builder][:web_root] = node[:nginx][:web_root]

include_attribute "samba::default"
default[:magento_demo_builder][:samba][:shares] = node[:samba][:shares]

include_attribute "magento::default"
include_attribute "magento::override"
default[:magento_demo_builder][:build][:action] = node[:magento][:installation][:build][:action]
default[:magento_demo_builder][:build][:sample_data] = node[:magento][:installation][:build][:sample_data]