#
# Cookbook:: mailhog
# Recipe:: install_golang
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Install Golang
apt_package 'golang-go' do
    action :install
end
