# Cookbook:: app_controller
# Recipe:: service_launcher
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

mysql 'Restart Mysql' do
	action :restart
end

nginx 'Restart Nginx' do
	action :restart
end

mailhog 'Restart Mailhog' do
	action :restart
end

samba 'Restart Samba' do
	action :restart
end
