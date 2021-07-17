# Cookbook:: magento_demo_builder
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:magento_demo_builder][:init][:user] = node[:init][:os][:user]

include_attribute 'nginx::default'
default[:magento_demo_builder][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute 'mysql::default'
include_attribute 'mysql::override'
default[:magento_demo_builder][:mysql][:db_user] = node[:mysql][:db_user]
default[:magento_demo_builder][:mysql][:db_password] = node[:mysql][:db_password]
default[:magento_demo_builder][:mysql][:db_name] = node[:mysql][:db_name]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:magento_demo_builder][:magento][:build][:action] = node[:magento][:build][:action]
default[:magento_demo_builder][:magento][:build][:sample_data] = node[:magento][:build][:sample_data]

include_attribute 'magento_patches::default'
include_attribute 'magento_patches::override'
default[:magento_demo_builder][:magento_patches][:holding_area] = node[:magento_patches][:holding_area]
