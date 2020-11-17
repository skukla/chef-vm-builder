#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:magento][:build][:action]

include_recipe "magento::uninstall"
include_recipe "magento::setup"

if build_action == "restore"
    include_recipe("magento_restore::default")
else
    include_recipe("magento::build")
end

include_recipe "magento::post_install"
include_recipe "magento::wrap_up"

