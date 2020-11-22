#
# Cookbook:: magento
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
build_action = node[:magento][:build][:action]
apply_deploy_mode = node[:magento][:build][:deploy_mode][:apply]

mysql 'Configure MySQL settings before installation' do
  action %i[configure_pre_app_install restart]
  not_if { ::File.exist?("#{web_root}/app/etc/config.php") && build_action == 'install' }
end

mysql 'Create the database' do
  action :create_database
end

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
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != 'reinstall' }
end

magento_app 'Upgrade Magento database' do
  action :db_upgrade
  only_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'update' }
end

magento_app 'Re-compile dependency injections' do
  action :di_compile
  not_if { apply_deploy_mode }
  only_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'update' }
end

magento_app 'Deploy static content' do
  action :deploy_static_content
  not_if { apply_deploy_mode }
  only_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'update' }
end

mysql 'Configure MySQL settings after installation' do
  action %i[configure_post_app_install restart]
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end

magento_app 'Set permissions after installation or database upgrade' do
  action :set_permissions
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end
