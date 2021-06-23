# Cookbook:: ssl
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
include_attribute 'init::override'
default[:ssl][:init][:user] = node[:init][:os][:user]
default[:ssl][:init][:demo_structure] = node[:init][:custom_demo][:structure]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:ssl][:magento][:settings][:use_secure_frontend] = node[:magento][:settings][:use_secure_frontend]
default[:ssl][:magento][:settings][:use_secure_admin] = node[:magento][:settings][:use_secure_admin]

DemoStructureHelper.get_vhost_data(node[:ssl][:init][:demo_structure]).each do |vhost|
  if (vhost[:scope] == 'website' && vhost[:code] == 'base') ||
     (vhost[:scope] == 'store_view' && vhost[:code] == 'default')
    default[:ssl][:common_name] = vhost[:url]
  end
end
