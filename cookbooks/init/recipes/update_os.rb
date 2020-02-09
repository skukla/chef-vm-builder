#
# Cookbook:: init
# Recipe:: update_os
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Update OS packages
execute 'Update OS packages' do
    command "sudo apt update -y && sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" upgrade -y && sudo sudo unattended-upgrade -d && sudo apt-get autoremove -y"
end
