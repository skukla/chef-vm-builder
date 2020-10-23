#
# Cookbook:: init
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
update_os = node[:init][:os][:update]
webserver_type = node[:init][:webserver][:type]

os "Update OS" do
    action :update
    only_if { update_os }
end

os "Configure OS" do
    action [:configure, :add_os_packages]
end

init "Install MOTD and update hosts file" do
    action [:install_motd, :update_hosts]
end

magento_app "Disable cron" do
    action :disable_cron
end

# We have to do these here because Nginx or Apache won't even install if port 80 is blocked
apache "Stop and remove Apache" do
    action [:stop, :uninstall]
    only_if { webserver_type == "nginx" }
end

nginx "Stop and remove Nginx" do
    action [:stop, :uninstall]
    only_if { webserver_type == "apache2" }
end