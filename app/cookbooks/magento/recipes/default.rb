#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:magento][:build][:action]

include_recipe "magento::uninstall"
include_recipe "magento::setup"

if build_action == "restore"
    include_recipe "magento_restore::default"
else
    include_recipe "magento::download"
    include_recipe "magento_demo_builder::default"
    include_recipe "magento::install"
    include_recipe "magento::configure"
end

include_recipe "magento::post_install"
include_recipe "magento::wrap_up"

