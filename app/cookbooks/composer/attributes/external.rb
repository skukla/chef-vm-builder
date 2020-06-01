#
# Cookbook:: composer
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:composer][:user] = node[:init][:os][:user]

include_attribute "nginx::default"
default[:composer][:web_root] = node[:nginx][:web_root]

include_attribute "magento::default"
include_attribute "magento::override"
default[:composer][:project_stability] = node[:magento][:installation][:options][:minimum_stability]