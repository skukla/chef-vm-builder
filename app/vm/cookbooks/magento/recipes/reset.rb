# Cookbook:: magento
# Recipe:: reset
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]

case build_action
when 'reinstall'
	magento_app 'Preparing reinstall' do
		action :prepare_reinstall
		only_if { ::File.exist?("#{web_root}/app/etc/env.php") }
	end
when 'force_install', 'restore'
	vm_cli 'Clearing the web root' do
		action :run
		command_list 'clear-web-root'
	end
end