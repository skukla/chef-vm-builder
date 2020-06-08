#
# Cookbook:: magento_configuration
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento_configuration][:user] = node[:init][:os][:user]

include_attribute "composer::default"
default[:magento_configuration][:composer][:file] = node[:composer][:file]

include_attribute "nginx::default"
default[:magento_configuration][:web_root] = node[:nginx][:web_root]

include_attribute "samba::default"
default[:magento_configuration][:samba_shares] = node[:samba][:shares]

include_attribute "elasticsearch::default"
default[:magento_configuration][:elasticsearch_port] = node[:elasticsearch][:port]

include_attribute "magento_custom_modules::default"
include_attribute "magento_custom_modules::override"
default[:magento_configuration][:custom_modules] = node[:magento_custom_modules][:module_list]

# We need both of these to ensure overrides are included for some reason
include_attribute "magento::default"
include_attribute "magento::override"
default[:magento_configuration][:magento_version] = node[:magento][:installation][:options][:version]
default[:magento_configuration][:magento_family] = node[:magento][:installation][:options][:family]
default[:magento_configuration][:database][:host] = node[:magento][:database][:host]
default[:magento_configuration][:database][:user] = node[:magento][:database][:user]
default[:magento_configuration][:database][:password] = node[:magento][:database][:password]
default[:magento_configuration][:database][:name] = node[:magento][:database][:name]