#
# Cookbook:: init
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:init][:os][:packages] = ["zip", "silversearcher-ag", "figlet", "unattended-upgrades"]
default[:init][:os][:update] = false
default[:init][:os][:timezone] = "America/Los_Angeles"
default[:init][:os][:user] = "vagrant"
