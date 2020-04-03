#
# Cookbook:: webmin
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_webmin = node[:infrastructure][:webmin][:use]

if use_webmin
    service 'webmin' do
        action [:enable, :start]
    end
end
