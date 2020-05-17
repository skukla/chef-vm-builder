#
# Cookbook:: magento
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento][:user] = node[:init][:os][:user]
default[:magento][:installation][:settings][:timezone] = node[:init][:os][:timezone]

include_attribute "composer::default"
default[:magento][:composer_file] = node[:composer][:file]
default[:magento][:composer_username] = node[:composer][:username]
default[:magento][:composer_password] = node[:composer][:password]
default[:magento][:github_token] = node[:composer][:github_token]

include_attribute "php::default"
default[:magento][:php_version] = node[:php][:version]
default[:magento][:fpm_backend] = node[:php][:backend]
default[:magento][:fpm_port] = node[:php][:port]

# We need both of these to include structure for some reason
include_attribute "nginx::default"
include_attribute "nginx::override"
default[:magento][:web_root] = node[:nginx][:web_root]
default[:magento][:structure] = node[:nginx][:structure]

include_attribute "elasticsearch::default"
default[:magento][:elasticsearch][:use] = node[:elasticsearch][:use]
default[:magento][:elasticsearch][:host] = node[:elasticsearch][:host]
default[:magento][:elasticsearch][:port] = node[:elasticsearch][:port]
default[:magento][:elasticsearch][:node_name] = node[:elasticsearch][:node_name]

include_attribute "magento_patches::default"
default[:magento][:patches][:apply] = node[:magento_patches][:apply]

include_attribute "magento_configuration::default"
default[:magento][:configuration][:flags][:base] = node[:magento_configuration][:flags][:base]
default[:magento][:configuration][:flags][:b2b] = node[:magento_configuration][:flags][:b2b]
default[:magento][:configuration][:flags][:custom_modules] = node[:magento_configuration][:flags][:custom_modules]
default[:magento][:configuration][:flags][:admin_users] = node[:magento_configuration][:flags][:admin_users]

include_attribute "magento_custom_modules::default"
default[:magento][:custom_modules] = node[:magento_custom_modules][:module_list]