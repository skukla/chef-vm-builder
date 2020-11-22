#
# Cookbook:: webmin
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_webmin = node[:webmin][:use]

mailhog 'Stop Mailhog' do
  action :stop
end

webmin 'Uninstall Webmin' do
  action :uninstall
  only_if { !use_webmin }
end

webmin 'Install and configure Webmin' do
  action %i[install configure]
  only_if { use_webmin }
end

mailhog 'Reload the mailhog daemon' do
  action :reload
  only_if { use_webmin }
end

webmin 'Stop and enable Webmin' do
  action %i[stop enable]
  only_if { use_webmin }
end
