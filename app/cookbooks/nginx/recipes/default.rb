#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
nginx "Install nginx" do
    action :install
end

init "Create web root" do
    action :create_web_root
end

nginx "Configure and enable Nginx" do
    action [:configure, :enable]
end

nginx "Clear sites, then configure and enable multisite and restart Nginx" do
    action [:clear_sites, :configure_multisite, :enable_multisite, :restart]
end

php "Restart PHP" do
    action :restart
end
