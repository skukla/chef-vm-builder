#
# Cookbook:: cli
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:cli][:user] = node[:init][:os][:user]

include_attribute "php::default"
default[:cli][:php][:version] = node[:php][:version]

include_attribute "mysql::default"
default[:cli][:database][:host] = node[:mysql][:db_host]
default[:cli][:database][:user] = node[:mysql][:db_user]
default[:cli][:database][:password] = node[:mysql][:db_password]
default[:cli][:database][:name] = node[:mysql][:db_name]

include_attribute "ssh::default"
default[:cli][:ssh][:private_keys_list] = node[:ssh][:private_keys][:files]

include_attribute "nginx::default"
default[:cli][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute "magento::default"
default[:cli][:magento][:version] = node[:magento][:installation][:options][:version]