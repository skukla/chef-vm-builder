# Cookbook:: magento
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
include_attribute 'init::override'
default[:magento][:init][:user] = node[:init][:os][:user]
default[:magento][:init][:timezone] = node[:init][:os][:timezone]
default[:magento][:init][:provider] = node[:init][:vm][:provider]

include_attribute 'mysql::default'
default[:magento][:mysql][:db_host] = node[:mysql][:db_host]
default[:magento][:mysql][:db_user] = node[:mysql][:db_user]
default[:magento][:mysql][:db_password] = node[:mysql][:db_password]
default[:magento][:mysql][:db_name] = node[:mysql][:db_name]

include_attribute 'composer::default'
include_attribute 'composer::override'
default[:magento][:composer][:file] = node[:composer][:file]
default[:magento][:composer][:public_key] = node[:composer][:public_key]
default[:magento][:composer][:private_key] = node[:composer][:private_key]
default[:magento][:composer][:github_token] = node[:composer][:github_token]
default[:magento][:composer][:allowed_plugins_list] =
  node[:composer][:allowed_plugins_list]

include_attribute 'nginx::default'
default[:magento][:nginx][:web_root] = node[:nginx][:web_root]
default[:magento][:nginx][:tmp_dir] = node[:nginx][:tmp_dir]

include_attribute 'php::default'
default[:magento][:php][:version] = node[:php][:version]
default[:magento][:php][:fpm_backend] = node[:php][:backend]
default[:magento][:php][:fpm_port] = node[:php][:fpm_port]

include_attribute 'search_engine::default'
default[:magento][:search_engine][:type] = node[:search_engine][:type]

default[:magento][:search_engine][:setting][:config_path] =
  node[:search_engine][:elasticsearch][:setting][:config_path]
default[:magento][:search_engine][:setting][:value] =
  node[:search_engine][:elasticsearch][:setting][:value]

default[:magento][:search_engine][:host][:config_path] =
  node[:search_engine][:elasticsearch][:host][:config_path]
default[:magento][:search_engine][:host][:value] =
  node[:search_engine][:elasticsearch][:host][:value]

default[:magento][:search_engine][:port][:config_path] =
  node[:search_engine][:elasticsearch][:port][:config_path]
default[:magento][:search_engine][:port][:value] =
  node[:search_engine][:elasticsearch][:port][:value]

default[:magento][:search_engine][:prefix][:config_path] =
  node[:search_engine][:elasticsearch][:prefix][:config_path]
default[:magento][:search_engine][:prefix][:value] =
  node[:search_engine][:elasticsearch][:prefix][:value]

default[:magento][:search_engine][:elasticsearch][:module_list] =
  node[:search_engine][:elasticsearch][:module_list]

default[:magento][:search_engine][:open_search][:module_list] =
  node[:search_engine][:open_search][:module_list]

default[:magento][:search_engine][:live_search][:module_list] =
  node[:search_engine][:live_search][:module_list]

include_attribute 'mailhog::default'
default[:magento][:mailhog][:mh_port] = node[:mailhog][:mh_port]

include_attribute 'magento_modules::default'
include_attribute 'magento_modules::override'
default[:magento][:magento_modules][:sample_data_module_list] =
  node[:magento_modules][:sample_data_module_list]
default[:magento][:magento_modules][:packagist_module_list] =
  node[:magento_modules][:packagist_module_list]
default[:magento][:magento_modules][:github_module_list] =
  node[:magento_modules][:github_module_list]
default[:magento][:magento_modules][:repositories_to_remove_list] =
  node[:magento_modules][:repositories_to_remove_list]
default[:magento][:magento_modules][:modules_to_remove_list] =
  node[:magento_modules][:modules_to_remove_list]

include_attribute 'magento_demo_builder::override'
default[:magento][:data_packs][:github_data_pack_list] =
  node[:magento_demo_builder][:github_data_pack_list]
default[:magento][:data_packs][:local_data_pack_list] =
  node[:magento_demo_builder][:local_data_pack_list]

include_attribute 'magento_patches::default'
default[:magento][:patches][:apply] = node[:magento_patches][:apply]

include_attribute 'magento_restore::default'
include_attribute 'magento_restore::override'
default[:magento][:magento_restore][:mode] = node[:magento_restore][:mode]
