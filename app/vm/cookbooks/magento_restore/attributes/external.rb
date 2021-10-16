# Cookbook:: magento_restore
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:magento_restore][:init][:user] = node[:init][:os][:user]

include_attribute 'nginx::default'
default[:magento_restore][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute 'composer::default'
include_attribute 'composer::override'
default[:magento_restore][:composer][:github_token] =
	node[:composer][:github_token]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:magento_restore][:magento][:build][:action] =
	node[:magento][:build][:action]
