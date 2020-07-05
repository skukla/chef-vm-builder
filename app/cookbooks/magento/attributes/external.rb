#
# Cookbook:: magento
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento][:init][:user] = node[:init][:os][:user]
default[:magento][:init][:timezone] = node[:init][:os][:timezone]
default[:magento][:init][:web_root] = node[:init][:webserver][:web_root]

include_attribute "mysql::default"
default[:magento][:mysql][:db_host] = node[:mysql][:db_host]
default[:magento][:mysql][:db_user] = node[:mysql][:db_user]
default[:magento][:mysql][:db_password] = node[:mysql][:db_password]
default[:magento][:mysql][:db_name] = node[:mysql][:db_name]

include_attribute "composer::default"
default[:magento][:composer][:file] = node[:composer][:file]
default[:magento][:composer][:public_key] = node[:composer][:public_key]
default[:magento][:composer][:private_key] = node[:composer][:private_key]
default[:magento][:composer][:github_token] = node[:composer][:github_token]

include_attribute "php::default"
default[:magento][:php][:version] = node[:php][:version]
default[:magento][:php][:fpm_backend] = node[:php][:backend]
default[:magento][:php][:fpm_port] = node[:php][:port]

include_attribute "elasticsearch::default"
default[:magento][:elasticsearch][:use] = node[:elasticsearch][:use]
default[:magento][:elasticsearch][:host] = node[:elasticsearch][:host]
default[:magento][:elasticsearch][:port] = node[:elasticsearch][:port]
default[:magento][:elasticsearch][:node_name] = node[:elasticsearch][:node_name]

include_attribute "magento_custom_modules::default"
default[:magento][:custom_modules] = node[:magento_custom_modules][:module_list]

include_attribute "magento_patches::default"
default[:magento][:patches][:apply] = node[:magento_patches][:apply]

include_attribute "magento_configuration::default"
default[:magento][:configuration][:flags][:base] = node[:magento_configuration][:flags][:base]
default[:magento][:configuration][:flags][:b2b] = node[:magento_configuration][:flags][:b2b]
default[:magento][:configuration][:flags][:custom_modules] = node[:magento_configuration][:flags][:custom_modules]
default[:magento][:configuration][:flags][:admin_users] = node[:magento_configuration][:flags][:admin_users]
default[:magento][:configuration][:settings] = node[:magento_configuration][:settings]
default[:magento][:configuration][:admin_users] = node[:magento_configuration][:admin_users]