# Cookbook:: magento
# Recipe:: bootstrap
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

user = node[:magento][:init][:user]
build_action = node[:magento][:build][:action]
tmp_dir = node[:magento][:nginx][:tmp_dir]
web_root = node[:magento][:nginx][:web_root]
crontab = "/var/spool/cron/crontabs/#{user}"
sample_data_flag = "#{web_root}/var/.sample-data-state.flag"

php "Switch PHP user to #{user}" do
	action :set_user
	php_user user
end

if %w[update_all update_app].include?(build_action)
	magento_app 'Clear the cron schedule' do
		action :clear_cron_schedule
	end
end

magento_app 'Set auth.json credentials' do
	action :set_auth_credentials
end

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

if %w[update_all update_app].include?(build_action)
	execute 'Removing sample data flag' do
		command "rm -rf #{sample_data_flag}"
		only_if { ::File.exist?(sample_data_flag) }
	end
end

if %w[update_all update_app].include?(build_action)
	execute 'Clearing the temporary holding directory' do
		command "rm -rf #{tmp_dir}/*"
		only_if { ::File.exist?("#{web_root}/composer.json") }
	end
end
