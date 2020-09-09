#
# Cookbook:: magento_demo_builder
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
sample_data_flag = node[:magento_demo_builder][:magento][:build][:sample_data]
build_action = node[:magento_demo_builder][:magento][:build][:action]

magento_config "Create the product and content media drop directories" do
    action :create_media_drops
    not_if { sample_data_flag }
end

magento_demo_builder "Remove existing data from the database" do
    action :remove_data_patches
    only_if { build_action == "update" }
end

magento_demo_builder "Remove existing custom demo media" do
    action :remove_media
    not_if { sample_data_flag }
end

magento_demo_builder "Install custom demo data files" do
    action [:remove_data, :install_data]
end

magento_demo_builder "Copy custom demo media" do
    action :add_media
end

magento_app "Set permissions on media directories and files" do
    action :set_permissions
    permission_dirs ["var/", "pub/"]
end