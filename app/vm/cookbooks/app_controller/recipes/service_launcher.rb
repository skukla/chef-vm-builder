# Cookbook:: app_controller
# Recipe:: service_launcher
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

use_elasticsearch = node[:app_controller][:elasticsearch][:use]
use_mailhog = node[:app_controller][:mailhog][:use]
use_samba = node[:app_controller][:samba][:use]
use_webmin = node[:app_controller][:webmin][:use]

mysql 'Restart Mysql' do
	action :restart
end

nginx 'Restart Nginx' do
	action :restart
end

if use_mailhog
	mailhog 'Restart Mailhog' do
		action :restart
	end
end

if use_samba
	samba 'Restart Samba' do
		action :restart
	end
end

if use_webmin
	webmin 'Restart Webmin' do
		action :restart
	end
end
