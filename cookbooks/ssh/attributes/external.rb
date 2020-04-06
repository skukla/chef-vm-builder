#
# Cookbook:: ssh
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in init attributes
include_attribute 'init::default'

default[:infrastructure][:ssh][:user] = node[:vm][:user]
default[:infrastructure][:ssh][:group] = node[:vm][:group]