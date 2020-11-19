#
# Cookbook:: magento_restore
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento_restore][:init][:user] = node[:init][:os][:user]
default[:magento_restore][:init][:web_root] = node[:init][:webserver][:web_root]

include_attribute "mysql::default"
include_attribute "mysql::override"
default[:magento_restore][:mysql][:db_user] = node[:mysql][:db_user]
default[:magento_restore][:mysql][:db_password] = node[:mysql][:db_password]
default[:magento_restore][:mysql][:db_name] = node[:mysql][:db_name]