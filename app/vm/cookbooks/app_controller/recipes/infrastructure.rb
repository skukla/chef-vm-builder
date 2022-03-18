# Cookbook:: app_controller
# Recipe:: infrastructure
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

hypervisor = node[:app_controller][:init][:hypervisor]

include_recipe 'php::default'
include_recipe 'composer::default'
include_recipe 'ssl::default'
include_recipe 'nginx::default'
include_recipe 'mysql::default'
include_recipe 'mailhog::default'
include_recipe 'samba::default'
include_recipe 'search_engine::elasticsearch' if hypervisor.include?('vmware')
