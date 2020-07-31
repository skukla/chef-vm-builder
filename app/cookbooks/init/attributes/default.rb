#
# Cookbook:: init
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:init][:os][:user] = "vagrant"
default[:init][:os][:update] = false
default[:init][:os][:timezone] = "America/Los_Angeles"
default[:init][:os][:install_package_list] = [
    "zip", 
    "silversearcher-ag", 
    "figlet", 
    "unattended-upgrades"
]
default[:init][:webserver][:type] = "nginx"
default[:init][:webserver][:web_root] = "/var/www/magento"
