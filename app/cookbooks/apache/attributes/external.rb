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

include_attribute "ssl::default"
default[:apache][:ssl][:port] = node[:ssl][:port]
default[:apache][:ssl][:chainfile_directory] = node[:ssl][:chainfile_directory]
default[:apache][:ssl][:chainfile] = node[:ssl][:chainfile]
default[:apache][:ssl][:directory] = node[:ssl][:directory]
default[:apache][:ssl][:server_private_key_file] = node[:ssl][:server_private_key_file]
default[:apache][:ssl][:server_certificate_file] = node[:ssl][:server_certificate_file]

include_attribute "php::default"
default[:apache][:php][:version] = node[:php][:version]
default[:apache][:php][:fpm_backend] =  node[:php][:backend]
default[:apache][:php][:fpm_port] = node[:php][:port]