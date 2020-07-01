#
# Cookbook:: samba
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
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
    only_if { node[:samba][:use] }
end