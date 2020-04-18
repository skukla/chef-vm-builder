#
# Cookbook:: samba
# Recipe:: uninstall
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
samba_packages = node[:infrastructure][:samba][:packages]

samba_packages.each do |package|
    apt_package package do
        action [:remove, :purge]
        only_if "which smbd"
    end
end
