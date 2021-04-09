#
# Cookbook:: service_launcher
# Recipe:: pre_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_elasticsearch = node[:service_launcher][:elasticsearch][:use]

mysql 'Restart Mysql' do
  action :restart
end

nginx 'Restart Nginx' do
  action :restart
end

if use_elasticsearch
  elasticsearch 'Restart Elasticsearch' do
    action :restart
  end
end
