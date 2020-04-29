#
# Cookbook:: cli
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "php::default"
default[:cli][:php_version] = node[:php][:version]

include_attribute "magento::default"
default[:cli][:database_host] = node[:magento][:database][:host]
default[:cli][:database_user] = node[:magento][:database][:user]
default[:cli][:database_password] = node[:magento][:database][:password]
default[:cli][:database_name] = node[:magento][:database][:name]