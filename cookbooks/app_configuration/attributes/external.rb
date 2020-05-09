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
default[:app_configuration][:db_host] = node[:magento][:database][:host]
default[:app_configuration][:db_user] = node[:magento][:database][:user]
default[:app_configuration][:db_password] = node[:magento][:database][:password]
default[:app_configuration][:db_name] = node[:magento][:database][:name]