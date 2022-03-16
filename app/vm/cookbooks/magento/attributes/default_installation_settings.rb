# Cookbook:: magento
# Attribute:: default_installation_settings
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento][:settings][:backend_frontname] = 'admin'
default[:magento][:settings][:unsecure_base_url] = "http://#{node[:fqdn]}/"
default[:magento][:settings][:secure_base_url] = "https://#{node[:fqdn]}/"
default[:magento][:settings][:language] = 'en_US'
default[:magento][:settings][:currency] = 'USD'
default[:magento][:settings][:admin_firstname] = 'Admin'
default[:magento][:settings][:admin_lastname] = 'Admin'
default[:magento][:settings][:admin_email] = "admin@#{node[:fqdn]}"
default[:magento][:settings][:admin_user] = 'admin'
default[:magento][:settings][:admin_password] = 'admin123'
default[:magento][:settings][:use_rewrites] = 1
default[:magento][:settings][:use_secure_frontend] = 0
default[:magento][:settings][:use_secure_admin] = 0
default[:magento][:settings][:cleanup_database] = 1
default[:magento][:settings][:session_save] = 'db'
default[:magento][:settings][:encryption_key] =
	'5fb338b139111ece4fd8d80fabc900b5'
