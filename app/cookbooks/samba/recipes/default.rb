#
# Cookbook:: samba
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_samba = node[:samba][:use]
user = node[:samba][:user]
group = node[:samba][:user]
shares = node[:samba][:shares]

samba "Uninstall samba" do
    action :uninstall
end

samba "Install and configure samba" do
    action [:install, :configure]
    user "#{user}"
    group "#{group}"
    shares shares
    only_if { use_samba }
end