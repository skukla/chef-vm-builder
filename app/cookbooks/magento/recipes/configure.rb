#
# Cookbook:: magento
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
web_root = node[:magento][:init][:web_root]
use_elasticsearch = node[:magento][:elasticsearch][:use]
build_action = node[:magento][:build][:action]
custom_module_list = node[:magento][:custom_modules]
config_settings = node[:magento][:configuration][:settings]
admin_users = node[:magento][:configuration][:admin_users]
configuration_flags = node[:magento][:configuration][:flags]

php 'Switch PHP user to www-data' do
  action :set_user
  php_user 'www-data'
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
  only_if do
    ::File.exist?("#{web_root}/app/etc/config.php") &&
      (
          configuration_flags[:base] ||
          configuration_flags[:b2b] ||
          use_elasticsearch ||
          configuration_flags[:custom_modules] ||
          configuration_flags[:admin_users]
        )
  end
end

magento_config 'Configure base settings' do
  action :process_configuration
  config_group 'base'
  config_data config_settings
  not_if do
    (build_action == 'install' && ::File.exist?("#{web_root}/var/.first-run-state.flag")) ||
      !configuration_flags[:base]
  end
  only_if do
    ::File.exist?("#{web_root}/app/etc/config.php") &&
      configuration_flags[:base]
  end
end

magento_config 'Configure b2b settings' do
  action :process_configuration
  config_group 'b2b'
  config_data config_settings
  not_if do
    (build_action == 'install' && ::File.exist?("#{web_root}/var/.first-run-state.flag")) ||
      !configuration_flags[:b2b]
  end
  only_if do
    ::File.exist?("#{web_root}/app/etc/config.php") &&
      configuration_flags[:b2b]
  end
end

magento_config 'Configure search settings' do
  action :process_configuration
  config_group 'search'
  config_data config_settings
  not_if do
    (build_action == 'install' && ::File.exist?("#{web_root}/var/.first-run-state.flag")) ||
      !configuration_flags[:search]
  end
  only_if do
    ::File.exist?("#{web_root}/app/etc/config.php") &&
      configuration_flags[:search]
  end
end

magento_config 'Configure admin users' do
  action :process_admin_users
  config_group 'admin_users'
  config_data admin_users
  not_if do
    (build_action == 'install' && ::File.exist?("#{web_root}/var/.first-run-state.flag")) ||
      admin_users.empty? ||
      !configuration_flags[:admin_users]
  end
  only_if do
    ::File.exist?("#{web_root}/app/etc/config.php") &&
      !admin_users.empty? &&
      configuration_flags[:admin_users]
  end
end

php "Switch PHP user to #{user}" do
  action :set_user
  php_user user
  not_if { build_action == 'install' && ::File.exist?("#{web_root}/var/.first-run-state.flag") }
  only_if do
    ::File.exist?("#{web_root}/app/etc/config.php") &&
      (
          configuration_flags[:base] ||
          configuration_flags[:b2b] ||
          use_elasticsearch ||
          configuration_flags[:custom_modules] ||
          configuration_flags[:admin_users]
        )
  end
end

magento_app 'Set permissions' do
  action :set_permissions
  not_if do
    ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install'
  end
  only_if do
    ::File.exist?("#{web_root}/app/etc/config.php") &&
      (
          configuration_flags[:base] ||
          configuration_flags[:b2b] ||
          use_elasticsearch ||
          configuration_flags[:custom_modules] ||
          configuration_flags[:admin_users]
        )
  end
end
