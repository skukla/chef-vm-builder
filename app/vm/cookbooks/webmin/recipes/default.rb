#
# Cookbook:: webmin
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_webmin = node[:webmin][:use]

mailhog 'Stop Mailhog' do
	action :stop
end

if !use_webmin
	webmin 'Uninstall Webmin' do
		action :uninstall
	end
end

if use_webmin
	webmin 'Install and configure Webmin' do
		action %i[install configure]
	end

	mailhog 'Reload the mailhog daemon' do
		action :reload
	end

	webmin 'Stop and enable Webmin' do
		action %i[stop enable]
	end

	webmin 'Restart Webmin' do
		action :restart
	end
end
