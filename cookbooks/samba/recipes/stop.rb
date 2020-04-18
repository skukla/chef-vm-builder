#
# Cookbook:: samba
# Recipe:: stop
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_samba = node[:infrastructure][:samba][:use]

if use_samba
    service 'smbd' do
        action :stop
    end
end
