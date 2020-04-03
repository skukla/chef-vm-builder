#
# Cookbook:: mailhog
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_mailhog = node[:infrastructure][:mailhog][:use]

if use_mailhog
    service 'mailhog' do
        action [:enable, :start]
    end
end