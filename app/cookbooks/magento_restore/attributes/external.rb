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

include_attribute "composer::default"
include_attribute "composer::override"
default[:magento_restore][:composer][:github_token] = node[:composer][:github_token]

include_attribute "magento::default"
include_attribute "magento::override"
default[:magento_restore][:magento][:settings][:use_secure_frontend] = node[:magento][:settings][:use_secure_frontend]
default[:magento_restore][:magento][:settings][:use_secure_admin] = node[:magento][:settings][:use_secure_admin]