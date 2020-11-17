#
# Cookbook:: magento
# Recipe:: build
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe "magento::download"
include_recipe "magento_demo_builder::default"
include_recipe "magento::install"
include_recipe "magento::configure"