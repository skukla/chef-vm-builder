#
# Cookbook:: samba
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute 'init::default'
default[:samba][:init][:user] = node[:init][:os][:user]
default[:samba][:init][:web_root] = node[:init][:webserver][:web_root]
