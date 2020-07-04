#
# Cookbook:: magento_demo_builder
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento_demo_builder][:init][:user] = node[:init][:os][:user]
default[:magento_demo_builder][:init][:web_root] = node[:init][:webserver][:web_root]

include_attribute "mysql::default"
default[:magento_demo_builder][:mysql][:db_user] = node[:mysql][:db_user]
default[:magento_demo_builder][:mysql][:db_password] = node[:mysql][:db_password]
default[:magento_demo_builder][:mysql][:db_name] = node[:mysql][:db_name]

include_attribute "samba::default"
default[:magento_demo_builder][:samba][:shares] = node[:samba][:shares]

include_attribute "magento::default"
include_attribute "magento::override"
default[:magento_demo_builder][:magento][:build][:action] = node[:magento][:installation][:build][:action]
default[:magento_demo_builder][:magento][:build][:sample_data] = node[:magento][:installation][:build][:sample_data]