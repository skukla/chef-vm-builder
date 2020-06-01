#
# Cookbook:: php
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:php][:user] = node[:init][:os][:user]
default[:php][:timezone] = node[:init][:timezone]