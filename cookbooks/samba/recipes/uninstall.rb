#
# Cookbook:: samba
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
samba_packages = node[:infrastructure][:samba][:packages]

apt_package "samba" do
    action [:remove, :purge]
end
