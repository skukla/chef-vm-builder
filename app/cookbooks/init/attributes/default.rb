#
# Cookbook:: init
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:init][:os][:user] = "vagrant"
default[:init][:os][:update] = false
default[:init][:os][:timezone] = "America/Los_Angeles"
default[:init][:os][:install_package_list] = ["zip", "silversearcher-ag", "figlet", "unattended-upgrades"]
default[:init][:webserver][:apache_package_list] = ["apache2", "apache2-bin", "apache2-data", "apache2-utils"]
default[:init][:webserver][:type] = "apache" 
