# Cookbook:: app_controller
# Recipe:: service_launcher
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

use_webmin = node[:app_controller][:webmin][:use]

mailhog 'Restart Mailhog' do
	action :restart
end

samba 'Restart Samba' do
	action :restart
end

if use_webmin
	webmin 'Restart Webmin' do
		action :restart
	end
end
