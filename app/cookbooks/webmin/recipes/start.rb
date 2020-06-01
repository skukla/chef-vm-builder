#
# Cookbook:: webmin
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
if node[:webmin][:use]
    service 'webmin' do
        action :start
    end
end
