#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
web_root = node[:application][:webserver][:web_root]
custom_demo_data = node[:custom_demo]
download_flag = node[:application][:installation][:options][:download]
sample_data_flag = node[:application][:installation][:options][:sample_data]
install_flag = node[:application][:installation][:options][:install]
apply_patches_flag = node[:application][:installation][:options][:apply_patches]
# Check for B2B flag
b2b_values = Array.new
custom_demo_data.each do |vertical_key, vertical_value|
    vertical_value.each do |channel_key, channel_value|
        b2b_values << vertical_value[channel_key][:use]
    end
end
b2b_flag = b2b_values.include? true

# Recipes
if download_flag && File.directory?("#{web_root}") && !Dir.empty?("#{web_root}")
    include_recipe 'magento::uninstall'
    include_recipe 'magento::create_project'
elsif download_flag
    include_recipe 'magento::create_project'
end
if download_flag && b2b_flag
    include_recipe 'magento::download_b2b'
end
if apply_patches_flag
    include_recipe 'magento::apply_patches'
end
if download_flag
    include_recipe 'magento::download'
end
if sample_data_flag
    include_recipe 'magento::sample_data'
end
if install_flag
    include_recipe 'magento::database'
    include_recipe 'magento::install'
end
if b2b_flag
    include_recipe 'magento::configure_b2b'
end
include_recipe 'magento::configure_nginx'
include_recipe 'magento::configure_app'
