# Cookbook:: composer
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:composer][:init][:user] = node[:init][:os][:user]

include_attribute 'nginx::default'
default[:composer][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:composer][:magento][:project_stability] =
	node[:magento][:options][:minimum_stability]
