#
# Cookbook:: magento_demo_builder
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
sample_data_flag = node[:magento_demo_builder][:magento][:build][:sample_data]
build_action = node[:magento_demo_builder][:magento][:build][:action]
web_root = node[:magento_demo_builder][:init][:web_root]
demo_shell_path = node[:magento_demo_builder][:demo_shell][:directory]
fixtures_directory = node[:magento_demo_builder][:demo_shell][:fixtures_directory]
demo_shell_module_files = node[:magento_demo_builder][:demo_shell][:module_files]

magento_config "Create samba drop directories" do
    action :create_samba_drops
end

magento_demo_builder "Create codebase media directories" do
    action :create_codebase_media_drops
end

magento_demo_builder "Remove existing data from the database" do
    action :remove_data_patches
    only_if { 
        build_action == "update" &&
        Dir.exist?("#{web_root}/#{demo_shell_path}") 
    }
end

magento_demo_builder "Remove existing custom demo media" do
    action [:remove_demo_shell_media, :remove_codebase_media]
    only_if { Dir.exist?("#{web_root}/#{demo_shell_path}") }
    not_if { sample_data_flag }
end

magento_demo_builder "Install custom demo data files into demo shell module" do
    action [:remove_data, :install_data]
    only_if { Dir.exist?("#{web_root}/#{demo_shell_path}/#{fixtures_directory}") }
end

magento_demo_builder "Build demo shell module" do
    action :build_demo_shell_module
end

magento_demo_builder "Copy demo shell media into place" do
    action [:add_media_to_demo_shell, :map_demo_shell_media_to_codebase]
    only_if { Dir.exist?("#{web_root}/#{demo_shell_path}") }
end

magento_demo_builder "Copy custom module media into place" do
    action [:map_custom_module_media_to_codebase, :map_data_pack_media_to_codebase]
end

magento_app "Set permissions on media directories and files" do
    action :set_permissions
    permission_dirs ["var/", "pub/"]
end