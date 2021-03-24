#
# Cookbook:: init
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:init][:magento][:build_action]

include_recipe 'init::disable_cron'
case build_action
when 'install', 'force_install'
  include_recipe 'init::default'
  include_recipe 'vm_cli::default'
  include_recipe 'ssh::default'
  include_recipe 'php::default'
  include_recipe 'composer::default'
  include_recipe 'ssl::default'
  include_recipe 'nginx::default'
  include_recipe 'mysql::default'
  include_recipe 'elasticsearch::default'
  include_recipe 'webmin::default'
  include_recipe 'mailhog::default'
  include_recipe 'samba::default'
  include_recipe 'service_launcher::pre_install'
  include_recipe 'magento::default'
  include_recipe 'service_launcher::post_install'
when 'update', 'reinstall'
  include_recipe 'service_launcher::pre_install'
  include_recipe 'magento::default'
  include_recipe 'service_launcher::post_install'
when 'refresh'
  include_recipe 'magento::default'
end
