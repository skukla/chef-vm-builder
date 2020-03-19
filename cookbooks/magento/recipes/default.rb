#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
web_root = node[:application][:webserver][:web_root]
custom_demo_data = node[:custom_demo]
download_base_code_flag = node[:application][:installation][:options][:download][:base_code]
download_custom_modules_flag = node[:application][:installation][:options][:download][:custom_modules]
sample_data_flag = node[:application][:installation][:options][:sample_data]
install_flag = node[:application][:installation][:options][:install]
apply_patches_flag = node[:application][:installation][:options][:apply_patches]
# Check for B2B flag
download_b2b_flag = node[:application][:installation][:options][:download][:b2b_code]
b2b_values = Array.new
custom_demo_data.each do |vertical_key, vertical_value|
    vertical_value.each do |channel_key, channel_value|
        b2b_values << vertical_value[channel_key][:use]
    end
end
b2b_flag = true if b2b_values.include? true && download_b2b_flag

# Recipes
# If download base is configured, and web root exists but is not empty
if download_base_code_flag && File.directory?("#{web_root}") && !Dir.empty?("#{web_root}")
    # Clear the web root, then install
    include_recipe 'magento::uninstall'
    include_recipe 'magento::create_project'
# Otherwise, as long as the web root exists...
elsif download_base_code_flag
    include_recipe 'magento::create_project'
end
# If B2B is comnfigured and code should be dowloaded, add it to composer.json
if b2b_flag
    include_recipe 'magento::download_b2b'
end
# If custom modules are configured, add them to composer.json
if download_custom_modules_flag
    include_recipe 'magento::download_custom_modules'
end
# If patches are comnfigured, add them to composer.json
if apply_patches_flag
    include_recipe 'magento::apply_patches'
end
# If download base code is configured, do composer install
if download_base_code_flag
    include_recipe 'magento::composer_install'
# Otherwise, if we just want custom modules to be added, do composer update
elsif download_custom_modules_flag && !download_base_code_flag
    include_recipe 'magento::composer_update'
end
# Add sample data after initial code download
if sample_data_flag
    include_recipe 'magento::sample_data'
end
# Do these things only after installation, not subsequent extension installs
if install_flag 
    include_recipe 'magento::database'
    include_recipe 'magento::install'
    include_recipe 'magento::configure_nginx'
    include_recipe 'magento::configure_app_base'
    if b2b_flag
        include_recipe 'magento::configure_b2b'
    end
end
# Do these things after base install and additional extension installs
include_recipe 'magento::configure_app_post_install'
