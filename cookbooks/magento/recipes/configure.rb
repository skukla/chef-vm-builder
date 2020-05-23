#
# Cookbook:: magento
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]
family = node[:magento][:installation][:options][:family]
custom_modules = node[:magento][:custom_modules]
configure_base = node[:magento][:configuration][:flags][:base]
configure_b2b = node[:magento][:configuration][:flags][:b2b]
use_elasticsearch = node[:magento][:use_elasticsearch]
configure_custom_modules = node[:magento][:configuration][:flags][:custom_modules]
configure_admin_users = node[:magento][:configuration][:flags][:admin_users]

switch_php_user "www-data" do
    only_if { configure_base || configure_b2b || use_elasticsearch || configure_custom_modules || configure_admin_users }
end

include_recipe "magento_configuration::configure" if File.exist?("#{web_root}/app/etc/config.php")
include_recipe "magento_custom_modules::configure" if File.exist?("#{web_root}/app/etc/config.php") && !custom_modules.nil? && configure_custom_modules

magento_app "Set permissions" do
    action :set_permissions
    only_if { configure_base || configure_b2b || use_elasticsearch || (module_list.nil? || configure_custom_modules) || configure_admin_users }
end

switch_php_user "#{user}" do
    only_if { configure_base || configure_b2b || use_elasticsearch || configure_custom_modules || configure_admin_users }
end