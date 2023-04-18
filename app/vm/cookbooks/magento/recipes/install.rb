# Cookbook:: magento
# Recipe:: install
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

build_action = node[:magento][:build][:action]
search_engine_type = node[:magento][:search_engine][:type]
provider = node[:magento][:init][:provider]

if %w[restore].include?(build_action)
  magento_app 'Preparing to install after restoring backup' do
    action :prepare_restore
    only_if { ::Dir.exist?("#{web_root}/pub") }
  end
end

if %w[reinstall restore].include?(build_action)
  magento_app 'Preparing reinstall' do
    action :prepare_reinstall
    only_if { ::File.exist?("#{web_root}/app/etc/env.php") }
  end
end

if %w[install force_install reinstall restore update_all update_app].include?(
     build_action,
   ) && %w[vmware docker].include?(provider)
  elasticsearch 'Restarting elasticsearch' do
    action :restart
  end
end

if %w[install force_install reinstall restore].include?(build_action)
  magento_app 'Install Magento' do
    action :install
    install_settings(
      {
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
        elasticsearch_host: node[:magento][:search_engine][:host],
        elasticsearch_port: node[:magento][:search_engine][:port],
        elasticsearch_prefix: node[:magento][:search_engine][:prefix],
        use_rewrites: node[:magento][:settings][:use_rewrites],
        use_secure_frontend: node[:magento][:settings][:use_secure_frontend],
        use_secure_admin: node[:magento][:settings][:use_secure_admin],
        cleanup_database: %w[reinstall restore].include?(build_action) ? 0 : 1,
        session_save: node[:magento][:settings][:session_save],
        encryption_key: node[:magento][:settings][:encryption_key],
      },
    )
  end
end
