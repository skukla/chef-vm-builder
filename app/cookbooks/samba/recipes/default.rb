#
# Cookbook:: samba
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_samba = node[:samba][:use]

samba "Uninstall samba" do
    action :uninstall
end

samba "Install and configure samba" do
    action [:install, :configure]
    only_if { use_samba }
end