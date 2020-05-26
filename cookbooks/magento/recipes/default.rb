#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe "magento::uninstall"
include_recipe "magento::download"
include_recipe "magento::install"
include_recipe "magento::configure"
include_recipe "magento::wrap_up"