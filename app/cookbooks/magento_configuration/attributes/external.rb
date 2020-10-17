#
# Cookbook:: magento_configuration
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento_configuration][:init][:user] = node[:init][:os][:user]
default[:magento_configuration][:init][:web_root] = node[:init][:webserver][:web_root]

include_attribute "mysql::default"
default[:magento_configuration][:database][:host] = node[:mysql][:db_host]
default[:magento_configuration][:database][:user] = node[:mysql][:db_user]
default[:magento_configuration][:database][:password] = node[:mysql][:db_password]
default[:magento_configuration][:database][:name] = node[:mysql][:db_name]

include_attribute "composer::default"
default[:magento_configuration][:composer][:file] = node[:composer][:file]

include_attribute "samba::default"
include_attribute "samba::override"
default[:magento_configuration][:samba][:share_list] = node[:samba][:share_list]

include_attribute "elasticsearch::default"
default[:magento_configuration][:elasticsearch][:use] = node[:elasticsearch][:use]
default[:magento_configuration][:elasticsearch][:port] = node[:elasticsearch][:port]

include_attribute "magento_custom_modules::default"
include_attribute "magento_custom_modules::override"
default[:magento_configuration][:custom_modules] = node[:magento_custom_modules][:module_list]

# We need both of these to ensure overrides are included for some reason
include_attribute "magento::default"
include_attribute "magento::override"
default[:magento_configuration][:magento_version] = node[:magento][:options][:version]
default[:magento_configuration][:magento_family] = node[:magento][:options][:family]
default[:magento_configuration][:magento][:build_action] = node[:magento][:build][:action]