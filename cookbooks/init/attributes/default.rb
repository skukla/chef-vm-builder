#
# Cookbook:: init
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:init][:packages] = ["zip", "silversearcher-ag", "figlet", "unattended-upgrades", "keychain"]
default[:init][:update] = false
default[:init][:timezone] = "America/Los_Angeles"
