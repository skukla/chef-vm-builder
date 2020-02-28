#
# Cookbook:: magento
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in attributes from other cookbooks
include_attribute 'init::default'
include_attribute 'nginx::default'
include_attribute 'mysql::default'
include_attribute 'composer::default'

default[:application][:user] = node[:vm][:user]
default[:application][:group] = node[:vm][:group]
default[:application][:database][:root_password] = node[:infrastructure][:database][:root_user][:password]
default[:application][:webserver][:web_root] = node[:infrastructure][:webserver][:conf_options][:web_root]
default[:application][:composer][:install_dir] = node[:infrastructure][:composer][:install_dir]
default[:application][:composer][:filename] = node[:infrastructure][:composer][:filename]
