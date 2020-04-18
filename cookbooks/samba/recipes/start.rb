#
# Cookbook:: samba
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_samba = node[:infrastructure][:webmin][:use]

if use_samba
    service 'smbd' do
        action :start
    end
end
