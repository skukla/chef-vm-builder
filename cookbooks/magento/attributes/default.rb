#
# Cookbook:: magento
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:magento][:database][:host] = "localhost"
default[:magento][:database][:user] = "magento"
default[:magento][:database][:password] = "password"
default[:magento][:database][:name] = "magento"

default[:magento][:installation][:options][:family] = "Open Source"
default[:magento][:installation][:options][:version] = "2.3.4"
default[:magento][:installation][:build][:install] = true
default[:magento][:installation][:build][:base_code] = true
default[:magento][:installation][:build][:b2b_code] = true
default[:magento][:installation][:build][:custom_modules] = true
default[:magento][:installation][:build][:modules_to_remove] = []
default[:magento][:installation][:build][:sample_data] = true
default[:magento][:installation][:build][:patches][:magentoly] = false
default[:magento][:installation][:build][:deploy_mode][:magentoly] = true
default[:magento][:installation][:build][:deploy_mode][:mode] = "production"
default[:magento][:installation][:build][:configuration][:base] = false
default[:magento][:installation][:build][:configuration][:b2b] = false
default[:magento][:installation][:build][:configuration][:custom_modules] = false
default[:magento][:installation][:build][:configuration][:admin_users] = false

default[:magento][:installation][:settings][:backend_frontname] = "admin"
default[:magento][:installation][:settings][:unsecure_base_url] = "http://#{node[:fqdn]}/"
default[:magento][:installation][:settings][:secure_base_url] = "https://#{node[:fqdn]}/"
default[:magento][:installation][:settings][:language] = "en_US"
default[:magento][:installation][:settings][:currency] = "USD"
default[:magento][:installation][:settings][:admin_firstname] = "Admin"
default[:magento][:installation][:settings][:admin_lastname] = "Admin"
default[:magento][:installation][:settings][:admin_email] = "admin@#{node[:fqdn]}"
default[:magento][:installation][:settings][:admin_user] = "admin"
default[:magento][:installation][:settings][:admin_password] = "admin123"
default[:magento][:installation][:settings][:use_rewrites] = 1
default[:magento][:installation][:settings][:use_secure_frontend] = 0
default[:magento][:installation][:settings][:use_secure_admin] = 0
default[:magento][:installation][:settings][:cleanup_database] = 1
default[:magento][:installation][:settings][:session_save] = "db"
default[:magento][:installation][:settings][:encryption_key] = "5fb338b139111ece4fd8d80fabc900b5"