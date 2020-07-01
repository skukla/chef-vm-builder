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

php "Switch PHP user to www-data" do
    action :set_user
    php_user "www-data"
    not_if {
        build_action == "install" &&
        ::File.exist?("#{web_root}/var/.first-run-state.flag")
    }
    only_if { 
        ::File.exist?("#{web_root}/app/etc/config.php") && 
        (
            configure_base || 
            configure_b2b || 
            use_elasticsearch || 
            configure_custom_modules || 
            configure_admin_users
        ) 
    }
end

magento_config "Configure base settings" do
    action :process_configuration
    config_group "base"
    config_paths config_paths
    config_data config_settings
    not_if {
        (build_action == "install" && ::File.exist?("#{web_root}/var/.first-run-state.flag")) ||
        !configure_base
    }
    only_if { 
        ::File.exist?("#{web_root}/app/etc/config.php") && 
        configure_base
    }
end

magento_config "Configure b2b settings" do
    action :process_configuration
    config_group "b2b"
    config_paths config_paths
    config_data config_settings
    not_if {
        (build_action == "install" && ::File.exist?("#{web_root}/var/.first-run-state.flag")) ||
        !configure_b2b
    }
    only_if { 
        ::File.exist?("#{web_root}/app/etc/config.php") && 
        configure_b2b
    }
end

magento_config "Configure search settings" do
    action :process_configuration
    config_group "search"
    config_paths config_paths
    config_data config_settings
    not_if {
        (build_action == "install" && ::File.exist?("#{web_root}/var/.first-run-state.flag")) ||
        (!use_elasticsearch)
    }
    only_if { 
        ::File.exist?("#{web_root}/app/etc/config.php") && 
        (use_elasticsearch)
    }
end

magento_config "Configure admin users" do
    action :process_admin_users
    config_group "admin_users"
    config_data admin_users
    not_if {
        (build_action == "install" && ::File.exist?("#{web_root}/var/.first-run-state.flag")) ||
        admin_users.empty? ||
        !configure_admin_users
    }
    only_if { 
        ::File.exist?("#{web_root}/app/etc/config.php") && 
        !admin_users.empty? &&
        configure_admin_users
    }
end

custom_module_config "Configure custom modules" do
    action :process_configuration
    module_list custom_modules
    not_if {
        (build_action == "install" && ::File.exist?("#{web_root}/var/.first-run-state.flag")) ||
        custom_modules.empty? ||
        !configure_custom_modules
    }
    only_if { 
        ::File.exist?("#{web_root}/app/etc/config.php") && 
        !custom_modules.empty? &&
        configure_custom_modules
    }
end

php "Switch PHP user to #{user}" do
    action :set_user
    php_user "#{user}"
    not_if {
        build_action == "install" &&
        ::File.exist?("#{web_root}/var/.first-run-state.flag")
    }
    only_if { 
        ::File.exist?("#{web_root}/app/etc/config.php") && 
        (
            configure_base || 
            configure_b2b || 
            use_elasticsearch || 
            configure_custom_modules || 
            configure_admin_users
        ) 
    }
end

magento_app "Set permissions" do
    action :set_permissions
    not_if {
        build_action == "install" &&
        ::File.exist?("#{web_root}/var/.first-run-state.flag")
    }
    only_if { 
        ::File.exist?("#{web_root}/app/etc/config.php") && 
        (
            configure_base || 
            configure_b2b || 
            use_elasticsearch || 
            configure_custom_modules || 
            configure_admin_users
        ) 
    }
end