#
# Cookbook:: init
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
update_os = node[:init][:os][:update]

os "Update OS" do
    action :update
    only_if { update_os }
end

os "Configure OS" do
    action [:configure, :add_os_packages]
end

init "Install MOTD" do
    action :install_motd
end

apache "Stop and remove Apache" do
    action [:stop, :uninstall]
end

nginx "Stop and remove Nginx" do
    action [:stop, :uninstall]
end