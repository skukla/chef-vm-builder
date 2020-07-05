#
# Cookbook:: cli
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:cli][:init][:user] = node[:init][:os][:user]
default[:cli][:init][:web_root] = node[:init][:webserver][:web_root]

include_attribute "php::default"
default[:cli][:php][:version] = node[:php][:version]

include_attribute "mysql::default"
default[:cli][:mysql][:db_host] = node[:mysql][:db_host]
default[:cli][:mysql][:db_user] = node[:mysql][:db_user]
default[:cli][:mysql][:db_password] = node[:mysql][:db_password]
default[:cli][:mysql][:db_name] = node[:mysql][:db_name]

include_attribute "ssh::default"
default[:cli][:ssh][:private_keys_list] = node[:ssh][:private_keys][:files]

include_attribute "magento::default"
default[:cli][:magento][:version] = node[:magento][:installation][:options][:version]