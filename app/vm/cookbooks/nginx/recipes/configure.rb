# Cookbook:: nginx
# Recipe:: configure
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

nginx 'Configure Nginx and enable multisite operation' do
	action %i[configure_nginx configure_multisite enable_multisite]
end

nginx 'Change user and group, enable, and restart Nginx' do
	action %i[set_permissions enable restart]
end

php 'Restart PHP' do
	action :restart
end
