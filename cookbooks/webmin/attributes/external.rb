#
# Cookbook:: webmin
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

include_attribute 'init::default'

default[:infrastructure][:webmin][:user] = node[:vm][:user]
default[:infrastructure][:webmin][:group] = node[:vm][:group]
