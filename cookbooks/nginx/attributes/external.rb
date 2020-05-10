#
# Cookbook:: nginx
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:nginx][:user] = node[:init][:user]

include_attribute 'php::default'
default[:nginx][:php_version] = node[:php][:version]
default[:nginx][:fpm_backend] =  node[:php][:backend]
default[:nginx][:fpm_port] = node[:php][:port]

include_attribute "magento::default"
default[:nginx][:web_root] = node[:magento][:installation][:options][:directory]
