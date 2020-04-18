#
# Cookbook:: nginx
# Recipe:: start
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Start nginx
service 'nginx' do
    action :start
end