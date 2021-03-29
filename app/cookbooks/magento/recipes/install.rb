#
# Cookbook:: magento
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:magento][:build][:action]

mysql 'Configure MySQL settings before installation' do
  action %i[configure_pre_app_install restart]
end

mysql 'Create the database' do
  action :create_database
end

if %w[install force_install reinstall].include?(build_action)
  magento_app 'Install Magento' do
    action :install
    install_settings({
                       backend_frontname: node[:magento][:settings][:backend_frontname],
                       unsecure_base_url: node[:magento][:settings][:unsecure_base_url],
                       secure_base_url: node[:magento][:settings][:secure_base_url],
                       language: node[:magento][:settings][:language],
                       timezone: node[:magento][:init][:timezone],
                       currency: node[:magento][:settings][:currency],
                       admin_firstname: node[:magento][:settings][:admin_firstname],
                       admin_lastname: node[:magento][:settings][:admin_lastname],
                       admin_email: node[:magento][:settings][:admin_email],
                       admin_user: node[:magento][:settings][:admin_user],
                       admin_password: node[:magento][:settings][:admin_password],
                       use_rewrites: node[:magento][:settings][:use_rewrites],
                       use_secure_frontend: node[:magento][:settings][:use_secure_frontend],
                       use_secure_admin: node[:magento][:settings][:use_secure_admin],
                       cleanup_database: node[:magento][:settings][:cleanup_database],
                       session_save: node[:magento][:settings][:session_save],
                       encryption_key: node[:magento][:settings][:encryption_key]
                     })
  end
end

mysql 'Configure MySQL settings after installation' do
  action %i[configure_post_app_install restart]
end

magento_app 'Set permissions after installation or database upgrade' do
  action :set_permissions
end
