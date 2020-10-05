#
# Cookbook:: magento_demo_builder
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
sample_data_flag = node[:magento_demo_builder][:magento][:build][:sample_data]
build_action = node[:magento_demo_builder][:magento][:build][:action]
web_root = node[:magento_demo_builder][:init][:web_root]
custom_module_list = node[:magento_demo_builder][:custom_module_list]
demo_shell_path = node[:magento_demo_builder][:demo_shell][:path]
fixtures_directory = node[:magento_demo_builder][:demo_shell][:fixtures_directory]
demo_shell_module_files = node[:magento_demo_builder][:demo_shell][:module_files]

magento_config "Create samba drop directories" do
    action :create_samba_drops
end

magento_demo_builder "Remove existing data from the database" do
    action :remove_data_patches
    only_if { 
        build_action == "update" &&
        Dir.exist?("#{web_root}/#{demo_shell_path}") 
    }
end

magento_demo_builder "Build demo shell module" do
    action :build_demo_shell_module
    only_if { Dir.exist?("#{web_root}/#{demo_shell_path}") }
end

magento_demo_builder "Create media drops" do
    action :create_codebase_media_drops
end

magento_demo_builder "Install custom demo data files into demo shell module" do
    action :install_local_content
    only_if { Dir.exist?("#{web_root}/#{demo_shell_path}/#{fixtures_directory}") }
end

magento_demo_builder "Copy local data pack media to codebase" do
    action :add_local_content_to_codebase
    not_if { custom_module_list.empty? }
    only_if { Dir.exist?("#{web_root}/#{demo_shell_path}") }
end

magento_demo_builder "Copy module-based data pack media to codebase" do
    action :add_module_content_to_codebase
    not_if { custom_module_list.empty? }
end

magento_app "Set permissions on media directories and files" do
    action :set_permissions
    permission_dirs ["var/", "pub/"]
end