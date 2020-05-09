#
# Cookbook:: init
# Recipe:: configure_timezone
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:init][:user]
timezone = node[:init][:timezone]

execute "Configure VM timezone" do
    command "sudo timedatectl set-timezone #{timezone}"
end