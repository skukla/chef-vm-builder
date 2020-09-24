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

magento_config "Create drop directories" do
    action [:create_samba_drops, :create_non_samba_drops]
    not_if { sample_data_flag }
end

magento_demo_builder "Remove existing data from the database" do
    action :remove_data_patches
    only_if { 
        build_action == "update" &&
        Dir.exist?("#{web_root}/#{demo_shell_path}/#{fixtures_directory}") 
    }
end

magento_demo_builder "Remove existing custom demo media" do
    action :remove_media
    only_if { Dir.exist?("#{web_root}/#{demo_shell_path}/#{fixtures_directory}") }
    not_if { sample_data_flag }
end

magento_demo_builder "Install custom demo data files" do
    action [:remove_data, :install_data]
    only_if { Dir.exist?("#{web_root}/#{demo_shell_path}/#{fixtures_directory}") }
end

magento_demo_builder "Copy custom demo media" do
    action :add_media
    only_if { Dir.exist?("#{web_root}/#{demo_shell_path}/#{fixtures_directory}") }
end

magento_app "Set permissions on media directories and files" do
    action :set_permissions
    permission_dirs ["var/", "pub/"]
end