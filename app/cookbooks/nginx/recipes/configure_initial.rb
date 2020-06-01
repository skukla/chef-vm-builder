#
# Cookbook:: nginx
# Recipe:: configure_initial
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:nginx][:user]

# Configure nginx
template "Nginx configuration" do
    source "nginx.conf.erb"
    path "/etc/nginx/nginx.conf"
    owner "root"
    group "root"
    mode "644"
    variables ({ user: "#{user}" })
    only_if { ::File.exist?("/etc/nginx/nginx.conf") }
end

# Remove the default site
link "/etc/nginx/sites-enabled/default" do
    to "/etc/nginx/sites-available/default"
    action :delete
    only_if { ::File.exist?("/etc/nginx/sites-available/default") }
end

# Enable the nginx service
service "nginx" do
    action :enable
end
