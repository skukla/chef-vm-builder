# Cookbook:: magento
# Recipe:: reset
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]

if ::Dir.exist?('/etc/mysql')
	if build_action == 'force_install'
		mysql 'Dropping extra databases' do
			action :drop_extra_databases
		end
	end

	if build_action == 'restore'
		mysql 'Dropping all databases' do
			action :drop_all_databases
		end
	end
end

if %w[force_install restore].include?(build_action)
	vm_cli 'Clearing the web root' do
		action :run
		command_list 'clear-web-root'
	end
end
