#
# Cookbook:: ssl
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:ssl][:user] = node[:init][:os][:user]