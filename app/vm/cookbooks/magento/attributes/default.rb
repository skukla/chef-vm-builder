# Cookbook:: magento
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento][:options][:family] = 'community'
default[:magento][:options][:minimum_stability] = 'stable'

default[:magento][:csc_options][:key_path] =
	'/var/chef/cache/cookbooks/magento/files/default'
default[:magento][:csc_options][:production_api_key] = ''
default[:magento][:csc_options][:project_id] = ''
default[:magento][:csc_options][:environment_id] = ''

default[:magento][:build][:action] = 'install'
default[:magento][:build][:modules_to_remove] = %w[
	magento/module-csp
	magento/module-cardinal-commerce
	magento/module-two-factor-auth
	allure-framework/allure-phpunit
]
default[:magento][:build][:sample_data] = true
default[:magento][:build][:deploy_mode][:apply] = true
default[:magento][:build][:deploy_mode][:mode] = 'production'

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
