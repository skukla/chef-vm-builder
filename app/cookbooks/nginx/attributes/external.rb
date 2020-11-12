#
# Cookbook:: nginx
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:nginx][:init][:user] = node[:init][:os][:user]
default[:nginx][:init][:web_root] = node[:init][:webserver][:web_root]
default[:nginx][:init][:webserver_type] = node[:init][:webserver][:type]
default[:nginx][:init][:demo_structure] = node[:init][:custom_demo][:structure]

include_attribute "ssl::default"
default[:nginx][:ssl][:port] = node[:ssl][:port]
default[:nginx][:ssl][:directory] = node[:ssl][:directory]
default[:nginx][:ssl][:server_private_key_file] = node[:ssl][:server_private_key_file]
default[:nginx][:ssl][:server_certificate_file] = node[:ssl][:server_certificate_file]

include_attribute "php::default"
default[:nginx][:php][:version] = node[:php][:version]
default[:nginx][:php][:fpm_backend] =  node[:php][:backend]
default[:nginx][:php][:fpm_port] = node[:php][:port]
