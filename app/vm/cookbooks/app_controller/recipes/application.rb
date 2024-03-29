# Cookbook:: app_controller
# Recipe:: application
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_recipe 'magento::bootstrap'
include_recipe 'magento::reset'
include_recipe 'magento::create_project'
include_recipe 'magento_restore::default'
include_recipe 'magento::setup_project'
include_recipe 'magento::add_modules'
include_recipe 'magento::download'
include_recipe 'magento::install'
include_recipe 'magento::post_install'
include_recipe 'magento_demo_builder::update'
include_recipe 'magento_demo_builder::build'
include_recipe 'magento_demo_builder::install'
include_recipe 'magento::set_urls'
include_recipe 'magento::wrap_up_begin'
include_recipe 'magento::wrap_up_end'
