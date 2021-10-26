# Cookbook:: nginx
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:nginx][:init][:user] = node[:init][:os][:user]

include_attribute 'ssl::default'
default[:nginx][:ssl][:ssl_port] = node[:ssl][:ssl_port]
default[:nginx][:ssl][:directory] = node[:ssl][:directory]
default[:nginx][:ssl][:server_private_key_file] =
	node[:ssl][:server_private_key_file]
default[:nginx][:ssl][:server_certificate_file] =
	node[:ssl][:server_certificate_file]

include_attribute 'php::default'
default[:nginx][:php][:version] = node[:php][:version]
default[:nginx][:php][:fpm_backend] = node[:php][:backend]
default[:nginx][:php][:fpm_port] = node[:php][:fpm_port]

include_attribute 'magento::default'
include_attribute 'magento::override'
default[:nginx][:magento][:settings][:use_secure_frontend] =
	node[:magento][:settings][:use_secure_frontend]
default[:nginx][:magento][:settings][:use_secure_admin] =
	node[:magento][:settings][:use_secure_admin]
