#
# Cookbook:: service_launcher
# Recipe:: post_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:service_launcher][:init][:magento][:build_action]
web_root = node[:service_launcher][:init][:web_root]
use_mailhog = node[:service_launcher][:mailhog][:use]
use_samba = node[:service_launcher][:samba][:use]
use_webmin = node[:service_launcher][:webmin][:use]

mailhog 'Restart Mailhog' do
  action :restart
  only_if { use_mailhog }
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end

samba 'Restart Samba' do
  action :restart
  only_if { use_samba }
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end

webmin 'Restart Webmin' do
  action :restart
  only_if { use_webmin }
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end
