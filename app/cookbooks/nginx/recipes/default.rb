#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
webserver_type = node[:nginx][:init][:webserver_type]

if webserver_type == 'nginx'
  nginx 'Install Nginx' do
    action :install
  end

  nginx 'Create web root and clear existing sites' do
    action %i[create_web_root clear_sites]
  end

  nginx 'Configure Nginx and enable multisite operation' do
    action %i[configure_nginx configure_multisite enable_multisite]
  end

  nginx 'Change user and group, enable, and restart Nginx' do
    action %i[set_permissions enable restart]
  end

  php 'Restart PHP' do
    action :restart
  end
end
