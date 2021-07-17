# Cookbook:: ssl
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
include_attribute 'init::override'
default[:ssl][:init][:user] = node[:init][:os][:user]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:ssl][:magento][:settings][:use_secure_frontend] =
	node[:magento][:settings][:use_secure_frontend]
default[:ssl][:magento][:settings][:use_secure_admin] =
	node[:magento][:settings][:use_secure_admin]

base_entry = DemoStructureHelper.get_base_entry
default[:ssl][:common_name] = base_entry[:url]
