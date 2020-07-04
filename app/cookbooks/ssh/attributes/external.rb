#
# Cookbook:: ssh
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:ssh][:init][:user] = node[:init][:os][:user]