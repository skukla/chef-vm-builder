#
# Cookbook:: app_controller
# Recipe:: application
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:app_controller][:init][:magento][:build_action]

case build_action
when 'install', 'force_install', 'restore', 'reinstall', 'update'
  include_recipe 'app_controller::service_launcher'
  include_recipe 'magento::default'
when 'refresh'
  include_recipe 'magento::default'
end
