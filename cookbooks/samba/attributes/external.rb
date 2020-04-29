#
# Cookbook:: samba
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "magento::default"
default[:samba][:web_root] = node[:magento][:installation][:options][:directory]