# Cookbook:: app_controller
# Recipe:: infrastructure
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

search_engine_type = node[:app_controller][:search_engine][:type]
hypervisor = node[:app_controller][:init][:hypervisor]

include_recipe 'php::default'
include_recipe 'composer::default'
include_recipe 'ssl::default'
include_recipe 'nginx::default'
include_recipe 'mysql::default'
include_recipe 'mailhog::default'
include_recipe 'samba::default'
if search_engine_type == 'elasticsearch' && hypervisor == 'vmware_fusion'
	include_recipe 'search_engine::elasticsearch'
end
