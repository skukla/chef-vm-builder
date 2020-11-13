#
# Cookbook:: init
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
update_os = node[:init][:os][:update]
build_action = node[:init][:magento][:build_action]

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
    only_if {
        ::File.exist?("/var/spool/cron/crontabs/#{user}") && 
        build_action != "install" 
    }
end