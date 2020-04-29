#
# Cookbook:: webmin
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_webmin = node[:infrastructure][:webmin] or node[:infrastructure][:webmin][:use]

if use_webmin
    service 'webmin' do
        action :start
    end
end
