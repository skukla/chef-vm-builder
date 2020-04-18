#
# Cookbook:: init
# Recipe:: install_packages
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Install some useful OS packages
[
    "zip", 
    "silversearcher-ag", 
    "figlet", 
    "unattended-upgrades"
].each do |package|
    apt_package package do
        action :install
    end
end
