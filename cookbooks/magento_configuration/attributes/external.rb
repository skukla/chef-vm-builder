#
# Cookbook:: magento_configuration
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento_configuration][:user] = node[:init][:os][:user]

include_attribute "composer::default"
default[:magento_configuration][:composer_file] = node[:composer][:file]

include_attribute "nginx::default"
default[:magento_configuration][:web_root] = node[:nginx][:web_root]

include_attribute "samba::default"
default[:magento_configuration][:samba_shares] = node[:samba][:shares]

include_attribute "elasticsearch::default"
default[:magento_configuration][:elasticsearch_port] = node[:elasticsearch][:port]

include_attribute "magento::default"
default[:magento_configuration][:magento_version] = node[:magento][:installation][:options][:version]
default[:magento_configuration][:db_host] = node[:magento][:database][:host]
default[:magento_configuration][:db_user] = node[:magento][:database][:user]
default[:magento_configuration][:db_password] = node[:magento][:database][:password]
default[:magento_configuration][:db_name] = node[:magento][:database][:name]