#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe 'nginx::install'
include_recipe 'nginx::configure'

nginx 'Restart Nginx' do
	action :restart
end
