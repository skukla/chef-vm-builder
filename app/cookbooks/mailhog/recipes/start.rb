#
# Cookbook:: mailhog
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
if node[:mailhog][:use]
    service 'mailhog' do
        action :start
    end
end