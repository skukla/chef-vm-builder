#
# Cookbook:: nginx
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Not sure why we need ::override here instead of ::default
include_attribute "init::default"
default[:nginx][:user] = node[:init][:os][:user]

include_attribute 'php::default'
default[:nginx][:php_version] = node[:php][:version]
default[:nginx][:fpm_backend] =  node[:php][:backend]
default[:nginx][:fpm_port] = node[:php][:port]
