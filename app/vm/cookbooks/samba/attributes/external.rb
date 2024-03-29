# Cookbook:: samba
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:samba][:init][:user] = node[:init][:os][:user]

include_attribute 'nginx::default'
default[:samba][:nginx][:web_root] = node[:nginx][:web_root]
