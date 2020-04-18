#
# Cookbook:: samba
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Install Samba packages
apt_package 'samba' do
    action :install
end

# Enable Samba
service 'smbd' do
    action :enable
end
