#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:magento][:build][:action]
web_root = node[:magento][:init][:web_root]
first_run_flag = "#{web_root}/var/.first-run-state.flag"
install_after_first_run = ::File.exist?(first_run_flag) && build_action == 'install'

unless install_after_first_run
  case build_action
  when 'restore'
    include_recipe 'magento::uninstall'
    include_recipe 'magento_restore::default'
    include_recipe 'magento::post_install'
    include_recipe 'magento::wrap_up'
  when 'reinstall'
    include_recipe 'magento::install'
    include_recipe 'magento::post_install'
    include_recipe 'magento::wrap_up'
  when 'refresh'
    include_recipe 'magento_demo_builder::update'
    include_recipe 'magento_demo_builder::build'
    include_recipe 'magento_demo_builder::install'
    include_recipe 'magento::post_install'
  when 'update'
    include_recipe 'magento::add_modules'
    include_recipe 'magento::download'
    include_recipe 'magento::install'
    include_recipe 'magento_demo_builder::build'
    include_recipe 'magento_demo_builder::install'
    include_recipe 'magento::post_install'
    include_recipe 'magento::wrap_up'
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
end
