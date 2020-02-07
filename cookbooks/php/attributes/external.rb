#
# Cookbook:: php
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in init attributes
include_attribute 'init::default'

default[:infrastructure][:php][:user] = node[:vm][:user]
default[:infrastructure][:php][:group] = node[:vm][:group]
