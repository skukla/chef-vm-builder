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

init "Remove Apache packages" do
    action :remove_apache_packages
    only_if { 
        "dpkg --get-selections | grep apache" &&
        webserver_type != "apache" 
    }
end

init "Install MOTD" do
    action :install_motd
end