#
# Cookbook:: nginx
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:nginx][:user]
web_root = node[:nginx][:web_root]

nginx "Configure nginx" do
    action :configure
    user "#{user}"
    only_if { ::File.exist?("/etc/nginx/nginx.conf") }
end

nginx "Create web root" do
    action :create_web_root
    not_if { ::File.directory?("#{web_root}") }
end

nginx "Enable nginx" do
    action :enable
end