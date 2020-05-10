#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:installation][:options][:directory]
use_elasticsearch = node[:magento][:use_elasticsearch]
custom_demo_data = node[:custom_demo][:structure]
install_flag = node[:application][:installation][:build][:install]
download_base_code_flag = node[:application][:installation][:build][:base_code]
download_b2b_flag = node[:application][:installation][:build][:b2b_code]
download_custom_modules_flag = node[:application][:installation][:build][:custom_modules]
download_sample_data_flag = node[:application][:installation][:build][:sample_data]
apply_patches_flag = node[:application][:installation][:build][:patches][:apply]
apply_deploy_mode_flag = node[:application][:installation][:build][:deploy_mode][:apply]
apply_base_flag = node[:application][:installation][:build][:configuration][:base]
apply_b2b_flag = node[:application][:installation][:build][:configuration][:b2b]
configure_admin_users_flag = node[:application][:installation][:build][:configuration][:admin_users]
apply_custom_flag = node[:application][:installation][:build][:configuration][:custom_modules]

# Run PHP as the VM user
switch_php_user "#{user}"

# Handle nginx conifiguration for multisite first
include_recipe 'nginx::configure_multisite' if install_flag
# If download base is configured, and web root exists but is not empty
if download_base_code_flag
    # Clear the web root, then install
    include_recipe 'magento::uninstall_cron'
    include_recipe 'mysql::start'
    include_recipe 'magento::uninstall_app'
    include_recipe 'magento::create_web_root'
    include_recipe 'magento::composer_create_project'
    include_recipe 'magento::set_project_stability'
    include_recipe 'magento::remove_modules'
end
# If B2B is comnfigured and code should be dowloaded, add it to composer.json
include_recipe 'magento::download_b2b' if download_b2b_flag
# If custom modules are configured, add them to composer.json
if download_custom_modules_flag
    include_recipe 'custom_modules::download'
end
# If patches are comnfigured, add them to composer.json
if apply_patches_flag
    include_recipe 'app_patches::download_patches'
    include_recipe 'app_patches::apply_patches'
end
# If download base code is configured, do composer install
if download_base_code_flag
    include_recipe 'magento::composer_install'
# Otherwise, if we just want custom modules to be added...
elsif download_custom_modules_flag && !download_base_code_flag
    include_recipe 'magento::uninstall_cron'
    include_recipe 'magento::clear_cron_schedule'
    include_recipe 'custom_modules::install'
    if !apply_deploy_mode_flag
        include_recipe 'magento::compile_di'
        include_recipe 'magento::deploy_static_content'
    end
end
# Add sample data after initial code download
include_recipe 'magento::download_sample_data' if download_sample_data_flag
# Do these things only after installation, not subsequent extension installs
if install_flag 
    include_recipe 'mysql::configure_pre_install'
    include_recipe 'magento::database'
    include_recipe 'magento::install'
    include_recipe 'mysql::configure_post_install'
end
# Do these things after base install and additional extension installs
# Using a shell script for php breaks if config strings have commas, so we use www-data here
switch_php_user "www-data"
if apply_base_flag
    include_recipe 'app_configuration::configure_defaults'
    include_recipe 'app_configuration::configure_elasticsearch' if use_elasticsearch
    include_recipe 'app_configuration::configure_app'
end
include_recipe 'app_configuration::configure_b2b' if apply_b2b_flag
if apply_custom_flag
    include_recipe 'custom_modules::configure_defaults'
    include_recipe 'custom_modules::configure_modules'
end
include_recipe 'app_configuration::configure_admin_users' if configure_admin_users_flag
# Configuration is done, so we switch back to the vm user
switch_php_user "#{user}" if apply_base_flag || apply_b2b_flag || apply_custom_flag
include_recipe 'magento::set_deploy_mode' if apply_deploy_mode_flag
include_recipe 'magento::setup_install' if install_flag
include_recipe 'app_configuration::create_image_drop'
include_recipe 'magento::setup_final'

# Note: All infrastructure services except nginx and mysql are started via the the application role