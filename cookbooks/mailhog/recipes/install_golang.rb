#
# Cookbook:: mailhog
# Recipe:: install_golang
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_mailhog = node[:infrastructure][:mailhog][:use]

# Install golang if configured to do so
if use_mailhog
    # Install Golang
    apt_package 'golang-go' do
        action :install
    end
end
