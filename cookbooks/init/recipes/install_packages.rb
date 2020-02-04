#
# Cookbook:: init
# Recipe:: install_packages
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Install some useful OS packages
['zip', 'silversearcher-ag', 'figlet', 'ppa-purge', 'unattended-upgrades'].each do |package|
    apt_package package do
        action :install
    end
end

# Update OS packages
# execute 'Update OS packages' do
#     command "sudo apt update -y && sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" upgrade -y && sudo sudo unattended-upgrade -d && sudo apt-get autoremove -y"
# end
