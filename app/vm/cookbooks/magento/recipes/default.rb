#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:magento][:build][:action]

include_recipe 'magento::setup'
case build_action
when 'restore'
  include_recipe 'magento::uninstall'
  include_recipe 'magento_restore::default'
  include_recipe 'magento::post_install'
  include_recipe 'magento::set_urls'
  include_recipe 'magento::wrap_up'
when 'reinstall'
  include_recipe 'magento::uninstall'
  include_recipe 'magento::install'
  include_recipe 'magento::post_install'
  include_recipe 'magento::set_urls'
  include_recipe 'magento::wrap_up'
when 'refresh'
  include_recipe 'magento_demo_builder::update'
  include_recipe 'magento_demo_builder::build'
  include_recipe 'magento_demo_builder::install'
  include_recipe 'magento::post_refresh'
  include_recipe 'magento::set_urls'
when 'update'
  include_recipe 'magento::project_setup'
  include_recipe 'magento::add_modules'
  include_recipe 'magento::download'
  include_recipe 'magento::install'
  include_recipe 'magento::post_install'
  include_recipe 'magento_demo_builder::build'
  include_recipe 'magento_demo_builder::install'
  include_recipe 'magento::set_urls'
  include_recipe 'magento::wrap_up'
when 'install', 'force_install'
  include_recipe 'magento::uninstall'
  include_recipe 'magento::project_setup'
  include_recipe 'magento::add_modules'
  include_recipe 'magento::download'
  include_recipe 'magento::install'
  include_recipe 'magento::post_install'
  include_recipe 'magento_demo_builder::build'
  include_recipe 'magento_demo_builder::install'
  include_recipe 'magento::set_urls'
  include_recipe 'magento::wrap_up'
end