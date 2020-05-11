#
# Cookbook:: composer
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:composer][:user] = node[:init][:os][:user]