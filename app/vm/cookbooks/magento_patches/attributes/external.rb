# Cookbook:: magento_patches
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:magento_patches][:init][:user] = node[:init][:os][:user]

include_attribute 'composer::default'
default[:magento_patches][:composer][:file] = node[:composer][:file]

include_attribute 'nginx::default'
default[:magento_patches][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute 'magento::default'
default[:magento_patches][:magento][:version] =
	node[:magento][:options][:version]
default[:magento_patches][:magento][:sample_data][:apply] =
	node[:magento][:build][:sample_data][:apply]
