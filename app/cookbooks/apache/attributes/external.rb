#
# Cookbook:: apache
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
include_attribute "init::override"
default[:apache][:init][:user] = node[:init][:os][:user]
default[:apache][:init][:web_root] = node[:init][:webserver][:web_root]
default[:apache][:init][:webserver_type] = node[:init][:webserver][:type]
default[:apache][:init][:demo_structure] = node[:init][:custom_demo][:structure]

include_attribute "php::default"
default[:apache][:php][:version] = node[:php][:version]
default[:apache][:php][:fpm_backend] =  node[:php][:backend]
default[:apache][:php][:fpm_port] = node[:php][:port]