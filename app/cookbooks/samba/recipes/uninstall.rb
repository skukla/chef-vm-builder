#
# Cookbook:: samba
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
apt_package "samba" do
    action [:remove, :purge]
end
