#
# Cookbook:: composer
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute 'init::default'
default[:composer][:init][:user] = node[:init][:os][:user]
default[:composer][:init][:web_root] = node[:init][:webserver][:web_root]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:composer][:magento][:project_stability] = node[:magento][:options][:minimum_stability]
