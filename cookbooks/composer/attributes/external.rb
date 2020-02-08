#
# Cookbook:: composer
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in init attributes
include_attribute 'init::default'

default[:infrastructure][:composer][:user] = node[:vm][:user]
default[:infrastructure][:composer][:group] = node[:vm][:group]
