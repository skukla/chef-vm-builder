#
# Cookbook:: nginx
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:nginx][:user] = node[:init][:os][:user]

include_attribute "ssl::default"
default[:nginx][:ssl][:port] = node[:ssl][:port]
default[:nginx][:ssl][:cert_directory] = node[:ssl][:cert_directory]
default[:nginx][:ssl][:key_directory] = node[:ssl][:key_directory]

include_attribute 'php::default'
default[:nginx][:php][:version] = node[:php][:version]
default[:nginx][:php][:fpm_backend] =  node[:php][:backend]
default[:nginx][:php][:fpm_port] = node[:php][:port]
