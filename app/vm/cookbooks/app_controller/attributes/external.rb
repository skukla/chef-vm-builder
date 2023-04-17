# Cookbook:: app_controller
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:app_controller][:init][:provider] = node[:init][:vm][:provider]

include_attribute 'nginx::default'
default[:app_controller][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute 'search_engine::default'
default[:app_controller][:search_engine][:type] = node[:search_engine][:type]

include_attribute 'magento::default'
default[:app_controller][:magento][:build_action] =
  node[:magento][:build][:action]
