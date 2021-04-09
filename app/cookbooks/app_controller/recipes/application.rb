#
# Cookbook:: app_controller
# Recipe:: application
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:init][:magento][:build_action]

case build_action
when 'install', 'force_install', 'restore', 'reinstall', 'update'
  include_recipe 'service_launcher::pre_install'
  include_recipe 'magento::default'
  include_recipe 'service_launcher::post_install'
when 'refresh'
  include_recipe 'magento::default'
end
