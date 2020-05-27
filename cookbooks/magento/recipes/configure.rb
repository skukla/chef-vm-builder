#
# Cookbook:: magento
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]
family = node[:magento][:installation][:options][:family]
build_action = node[:magento][:installation][:build][:action]
use_elasticsearch = node[:magento][:elasticsearch][:use]
custom_modules = node[:magento][:custom_modules]
config_paths = node[:magento][:configuration][:paths]
config_settings = node[:magento][:configuration][:settings]
admin_users = node[:magento][:configuration][:admin_users]
configure_base = node[:magento][:configuration][:flags][:base]
configure_b2b = node[:magento][:configuration][:flags][:b2b]
configure_custom_modules = node[:magento][:configuration][:flags][:custom_modules]
configure_admin_users = node[:magento][:configuration][:flags][:admin_users]

switch_php_user "www-data" do
    only_if { 
        ::File.exist?("#{web_root}/app/etc/config.php") && 
        (configure_base || configure_b2b || use_elasticsearch || configure_custom_modules || configure_admin_users) 
    }
end

magento_config "Configure base settings" do
    action :process_configuration
    config_group "base"
    config_paths config_paths
    config_data config_settings
    only_if { 
        (configure_base) && (!::File.exist?("#{web_root}/app/etc/config.php") && build_action == "install") || 
        (configure_base) && (::File.exist?("#{web_root}/app/etc/config.php") && build_action != "install") || 
        (configure_base && build_action == "force_install") 
    }
end

magento_config "Configure b2b settings" do
    action :process_configuration
    config_group "b2b"
    config_paths config_paths
    config_data config_settings
    only_if { 
        (configure_b2b) && (!::File.exist?("#{web_root}/app/etc/config.php") && build_action == "install") || 
        (configure_b2b) && (::File.exist?("#{web_root}/app/etc/config.php") && build_action != "install") || 
        (configure_b2b && build_action == "force_install") }
end

magento_config "Configure search settings" do
    action :process_configuration
    config_group "search"
    config_paths config_paths
    config_data config_settings
    only_if { 
        (use_elasticsearch) && (!::File.exist?("#{web_root}/app/etc/config.php") && build_action == "install") || 
        (use_elasticsearch) && (::File.exist?("#{web_root}/app/etc/config.php") && build_action != "install") || 
        (use_elasticsearch && build_action == "force_install") 
    }
end

magento_config "Configure admin users" do
    action :process_admin_users
    config_group "admin_users"
    config_data admin_users
    only_if { 
        ((configure_admin_users) && (!admin_users.empty?)) || 
        ((configure_custom_modules) && (!custom_modules.empty?)) && (!::File.exist?("#{web_root}/app/etc/config.php") && build_action == "install") || 
        ((configure_custom_modules) && (!custom_modules.empty?)) && (::File.exist?("#{web_root}/app/etc/config.php") && build_action != "install") || 
        ((configure_admin_users) && (!admin_users.empty?)) && (build_action == "force_install") 
    }
end

custom_module_config "Configure custom modules" do
    action :process_configuration
    module_list custom_modules
    only_if { 
        ((configure_custom_modules) && (!custom_modules.empty?)) || 
        ((configure_custom_modules) && (!custom_modules.empty?)) && (!::File.exist?("#{web_root}/app/etc/config.php") && build_action == "install") || 
        ((configure_custom_modules) && (!custom_modules.empty?)) && (::File.exist?("#{web_root}/app/etc/config.php") && build_action != "install") || 
        ((configure_custom_modules) && (!custom_modules.empty?)) && (build_action == "force_install") 
    }
end

magento_app "Set permissions" do
    action :set_permissions
    only_if { 
        configure_base || configure_b2b || use_elasticsearch || configure_custom_modules || configure_admin_users 
    }
end

switch_php_user "#{user}" do
    only_if { 
        ::File.exist?("#{web_root}/app/etc/config.php") && 
        (configure_base || configure_b2b || use_elasticsearch || configure_custom_modules || configure_admin_users) }
end