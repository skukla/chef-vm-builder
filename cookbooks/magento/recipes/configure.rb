#
# Cookbook:: magento
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
family = node[:magento][:installation][:options][:family]
custom_modules = node[:magento][:custom_modules]
admin_users = node[:magento][:admin_users]
configure_base = node[:magento][:configuration][:flags][:base]
configure_b2b = node[:magento][:configuration][:flags][:b2b]
configure_elasticsearch = node[:magento][:use_elasticsearch]
configure_custom_modules = node[:magento][:configuration][:flags][:custom_modules]
configure_admin_users = node[:magento][:configuration][:flags][:admin_users]

switch_php_user "www-data" do
    only_if { configure_base || configure_b2b || use_elasticsearch || (module_list.nil? || configure_custom_modules) || configure_admin_users }
end

include_recipe "magento_configuration::configure_defaults" if configure_base
include_recipe "magento_configuration::configure_app" if configure_base
include_recipe "magento_configuration::configure_b2b" if family == "enterprise" && !::File.foreach("#{web_root}/composer.json").grep(/extension-b2b/).any?
include_recipe "magento_configuration::configure_elasticsearch" if configure_elasticsearch
include_recipe "magento_custom_modules::configure" if !custom_modules.nil? && configure_custom_modules
include_recipe "magento_configuration::configure_admin_users" if !admin_users.nil? && configure_admin_users

magento_app "Set permissions" do
    action :set_permissions
    only_if { configure_base || configure_b2b || use_elasticsearch || (module_list.nil? || configure_custom_modules) || configure_admin_users }
end

switch_php_user "#{user}" do
    only_if { configure_base || configure_b2b || use_elasticsearch || (module_list.nil? || configure_custom_modules) || configure_admin_users }
end