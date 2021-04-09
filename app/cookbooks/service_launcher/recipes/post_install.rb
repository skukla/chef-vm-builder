#
# Cookbook:: service_launcher
# Recipe:: post_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_mailhog = node[:service_launcher][:mailhog][:use]
use_samba = node[:service_launcher][:samba][:use]
use_webmin = node[:service_launcher][:webmin][:use]

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
