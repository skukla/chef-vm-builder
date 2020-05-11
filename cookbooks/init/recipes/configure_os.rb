#
# Cookbook:: init
# Recipe:: configure_timezone
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:init][:os][:user]
timezone = node[:init][:os][:timezone]

execute "Configure VM timezone" do
    command "sudo timedatectl set-timezone #{timezone}"
end