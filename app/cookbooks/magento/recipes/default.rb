#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:magento][:build][:action]

case build_action
when 'restore'
  include_recipe 'magento::uninstall'
  include_recipe 'magento_restore::default'
when 'reinstall'
  include_recipe 'magento::install'
  magento_app 'Reindex and clear cache' do
    action %i[set_application_mode reset_indexers reindex clean_cache]
  end
when 'refresh'
  include_recipe 'magento_demo_builder::update'
  include_recipe 'magento_demo_builder::build'
  include_recipe 'magento_demo_builder::install'
  magento_app 'Reindex and clear cache' do
    action %i[reset_indexers reindex clean_cache]
  end
when 'update'
  include_recipe 'magento::add_modules'
  include_recipe 'magento::download'
  include_recipe 'magento::install'
  include_recipe 'magento_demo_builder::build'
  include_recipe 'magento_demo_builder::install'
  magento_app 'Process upgrade' do
    action %i[set_application_mode enable_cron reset_indexers reindex clean_cache]
  end
when 'install'
  include_recipe 'magento::create_project'
  include_recipe 'magento::add_modules'
  include_recipe 'magento::download'
  include_recipe 'magento::install'
  include_recipe 'magento_demo_builder::build'
  include_recipe 'magento_demo_builder::install'
  include_recipe 'magento::post_install'
  include_recipe 'magento::wrap_up'
when 'force_install'
  include_recipe 'magento::uninstall'
  include_recipe 'magento::create_project'
  include_recipe 'magento::add_modules'
  include_recipe 'magento::download'
  include_recipe 'magento::install'
  include_recipe 'magento_demo_builder::build'
  include_recipe 'magento_demo_builder::install'
  include_recipe 'magento::post_install'
  include_recipe 'magento::wrap_up'
end
