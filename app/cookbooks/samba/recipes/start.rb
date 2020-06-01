#
# Cookbook:: samba
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
if node[:samba][:use]
    service 'smbd' do
        action :start
    end
end
