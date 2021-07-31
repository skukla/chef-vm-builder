# Cookbook:: magento
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
include_attribute 'init::override'
default[:magento][:init][:user] = node[:init][:os][:user]
default[:magento][:init][:timezone] = node[:init][:os][:timezone]

include_attribute 'mysql::default'
default[:magento][:mysql][:db_host] = node[:mysql][:db_host]
default[:magento][:mysql][:db_user] = node[:mysql][:db_user]
default[:magento][:mysql][:db_password] = node[:mysql][:db_password]
default[:magento][:mysql][:db_name] = node[:mysql][:db_name]

include_attribute 'composer::default'
default[:magento][:composer][:file] = node[:composer][:file]
default[:magento][:composer][:public_key] = node[:composer][:public_key]
default[:magento][:composer][:private_key] = node[:composer][:private_key]
default[:magento][:composer][:github_token] = node[:composer][:github_token]

include_attribute 'nginx::default'
default[:magento][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute 'php::default'
default[:magento][:php][:version] = node[:php][:version]
default[:magento][:php][:fpm_backend] = node[:php][:backend]
default[:magento][:php][:fpm_port] = node[:php][:port]

include_attribute 'elasticsearch::default'
default[:magento][:elasticsearch][:use] = node[:elasticsearch][:use]
default[:magento][:elasticsearch][:host] = node[:elasticsearch][:host]
default[:magento][:elasticsearch][:port] = node[:elasticsearch][:port]
default[:magento][:elasticsearch][:node_name] = node[:elasticsearch][:node_name]

include_attribute 'magento_custom_modules::override'
default[:magento][:custom_modules][:module_list] =
	node[:magento_custom_modules][:module_list]

include_attribute 'magento_demo_builder::override'
default[:magento][:data_packs][:data_pack_list] =
	node[:magento_demo_builder][:data_pack_list]

include_attribute 'magento_patches::default'
default[:magento][:patches][:apply] = node[:magento_patches][:apply]
