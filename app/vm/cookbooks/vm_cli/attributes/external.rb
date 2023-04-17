# Cookbook:: cli
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:vm_cli][:init][:user] = node[:init][:os][:user]
default[:vm_cli][:init][:provider] = node[:init][:vm][:provider]

include_attribute 'nginx::default'
default[:vm_cli][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute 'php::default'
default[:vm_cli][:php][:version] = node[:php][:version]

include_attribute 'search_engine::default'
default[:vm_cli][:search_engine][:type] = node[:search_engine][:type]

include_attribute 'mysql::default'
default[:vm_cli][:mysql][:db_host] = node[:mysql][:db_host]
default[:vm_cli][:mysql][:db_user] = node[:mysql][:db_user]
default[:vm_cli][:mysql][:db_password] = node[:mysql][:db_password]
default[:vm_cli][:mysql][:db_name] = node[:mysql][:db_name]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:vm_cli][:magento][:version] = node[:magento][:options][:version]
default[:vm_cli][:magento][:use_secure_frontend] =
  node[:magento][:settings][:use_secure_frontend]

include_attribute 'magento_demo_builder::default'
default[:vm_cli][:magento_demo_builder][:build_dir] =
  node[:magento_demo_builder][:chef_files][:path]
default[:vm_cli][:magento_demo_builder][:local_data_pack_list] =
  node[:magento_demo_builder][:local_data_pack_list]

include_attribute 'magento_restore::default'
default[:vm_cli][:magento_restore][:backup_holding_area] =
  node[:magento_restore][:holding_area]
default[:vm_cli][:magento_restore][:backup_dir] =
  node[:magento_restore][:backup_dir]
