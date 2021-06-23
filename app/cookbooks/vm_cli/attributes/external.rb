# Cookbook:: cli
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:vm_cli][:init][:user] = node[:init][:os][:user]
default[:vm_cli][:init][:demo_structure] = node[:init][:custom_demo][:structure]

include_attribute 'nginx::default'
default[:vm_cli][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute 'php::default'
default[:vm_cli][:php][:version] = node[:php][:version]

include_attribute 'mysql::default'
default[:vm_cli][:mysql][:db_host] = node[:mysql][:db_host]
default[:vm_cli][:mysql][:db_user] = node[:mysql][:db_user]
default[:vm_cli][:mysql][:db_password] = node[:mysql][:db_password]
default[:vm_cli][:mysql][:db_name] = node[:mysql][:db_name]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:vm_cli][:magento][:version] = node[:magento][:options][:version]
default[:vm_cli][:magento][:use_secure_frontend] = node[:magento][:settings][:use_secure_frontend]
default[:vm_cli][:magento][:consumer_list] = node[:magento][:build][:consumer_list]
