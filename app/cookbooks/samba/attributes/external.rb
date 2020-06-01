#
# Cookbook:: samba
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:samba][:user] = node[:init][:os][:user]

include_attribute "nginx::default"
default[:samba][:web_root] = node[:nginx][:web_root]