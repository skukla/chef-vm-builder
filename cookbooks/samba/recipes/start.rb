#
# Cookbook:: samba
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_samba = node[:infrastructure][:webmin][:use]

if use_samba
    service 'smbd' do
        action [:enable, :start]
    end
end
