#
# Cookbook:: magento
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:magento][:build][:action]
web_root = node[:magento][:init][:web_root]

case build_action
when 'reinstall'
  magento_app 'Prepare reinstall' do
    action :prepare_reinstall
    only_if { ::File.exist?("#{web_root}/app/etc/env.php") }
  end
when 'force_install', 'restore'
  vm_cli 'Clearing the web root' do
    action :run
    command_list 'clear-web-root'
  end
end
