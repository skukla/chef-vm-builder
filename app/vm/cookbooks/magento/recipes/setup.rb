#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
build_action = node[:magento][:build][:action]
crontab = "/var/spool/cron/crontabs/#{user}"

php "Switch PHP user to #{user}" do
	action :set_user
	php_user user
end

if build_action == 'update'
	magento_app 'Clear the cron schedule' do
		action :clear_cron_schedule
		only_if { ::File.exist?(crontab) }
	end
end

magento_app 'Set auth.json credentials' do
	action :set_auth_credentials
end
