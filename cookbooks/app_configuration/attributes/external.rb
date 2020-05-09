#
# Cookbook:: app_configuration
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:app_configuration][:user] = node[:init][:user]

include_attribute "samba::default"
default[:app_configuration][:samba_shares] = node[:samba][:shares]

include_attribute "elasticsearch::default"
default[:app_configuration][:elasticsearch_port] = node[:elasticsearch][:port]

include_attribute "magento::default"
default[:app_configuration][:web_root] = node[:magento][:installation][:options][:directory]