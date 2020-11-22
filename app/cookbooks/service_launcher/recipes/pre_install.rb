#
# Cookbook:: service_launcher
# Recipe:: pre_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:service_launcher][:init][:magento][:build_action]
web_root = node[:service_launcher][:init][:web_root]
use_elasticsearch = node[:service_launcher][:elasticsearch][:use]

mysql 'Restart Mysql' do
  action :restart
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end

nginx 'Restart Nginx' do
  action :restart
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end

elasticsearch 'Restart Elasticsearch' do
  action :restart
  only_if { use_elasticsearch }
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end
