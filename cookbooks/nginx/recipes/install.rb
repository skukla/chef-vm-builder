#
# Cookbook:: nginx
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Install nginx
apt_package 'nginx' do
    action :install
end
