#
# Cookbook:: app_controller
# Recipe:: infrastructure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe 'php::default'
include_recipe 'composer::default'
include_recipe 'ssl::default'
include_recipe 'nginx::install'
include_recipe 'nginx::configure'
include_recipe 'mysql::default'
include_recipe 'elasticsearch::default'
include_recipe 'webmin::default'
include_recipe 'mailhog::default'
include_recipe 'samba::default'
