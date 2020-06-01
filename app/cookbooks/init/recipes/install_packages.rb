#
# Cookbook:: os
# Recipe:: install_packages
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
packages = node[:init][:os][:packages]

# Install some useful OS packages
packages.each do |package|
    apt_package package do
        action :install
    end
end
