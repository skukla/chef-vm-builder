#
# Cookbook:: nginx
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:infrastructure][:webserver][:user]
group = node[:infrastructure][:webserver][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]

# Create the web root
directory 'Web root directory' do
    path "#{web_root}"
    owner "#{user}"
    group "#{group}"
    mode '755'
    not_if { ::File.directory?("#{web_root}") }
end

# Configure nginx
template 'Nginx configuration' do
    source 'nginx.conf.erb'
    path '/etc/nginx/nginx.conf'
    owner 'root'
    group 'root'
    mode '644'
    variables ({ user: user })
    only_if { ::File.exists?('/etc/nginx/nginx.conf') }
end

# Remove the default site
link '/etc/nginx/sites-enabled/default' do
    to '/etc/nginx/sites-available/default'
    action :delete
    only_if { ::File.exists?('/etc/nginx/sites-available/default') }
end

# Define, enable, and start the nginx service and restart php
service 'nginx' do
    action [:enable, :start]
end
