#
# Cookbook:: magento_demo_builder
# Resource:: magento_demo_builder
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_demo_builder
provides :magento_demo_builder

property :name,                             String, name_property: true
property :user,                             String, default: node[:magento_demo_builder][:init][:user]
property :group,                            String, default: node[:magento_demo_builder][:init][:user]
property :web_root,                         String, default: node[:magento_demo_builder][:init][:web_root]
property :db_user,                          String, default: node[:magento_demo_builder][:mysql][:db_user]
property :db_password,                      String, default: node[:magento_demo_builder][:mysql][:db_password]
property :db_name,                          String, default: node[:magento_demo_builder][:mysql][:db_name]
property :patch_class,                      String, default: node[:magento_demo_builder][:demo_shell][:patch_class]
property :demo_shell_directory,             String, default: node[:magento_demo_builder][:demo_shell][:directory]
property :demo_shell_fixtures_directory,    String, default: node[:magento_demo_builder][:demo_shell][:fixtures_directory]
property :chef_data_files_path,             String, default: node[:magento_demo_builder][:data_files][:directory]
property :chef_patches_path,                String, default: node[:magento_demo_builder][:patches][:directory]
property :patches_holding_area,             String, default: node[:magento_demo_builder][:magento_patches][:holding_area]
property :chef_content_media_path,          String, default: node[:magento_demo_builder][:media_files][:content_directory]
property :chef_product_media_path,          String, default: node[:magento_demo_builder][:media_files][:products_directory]
property :chef_favicon_media_path,          String, default: node[:magento_demo_builder][:media_files][:favicon_directory]
property :chef_logo_media_path,             String, default: node[:magento_demo_builder][:media_files][:logo_directory]
property :wysiwyg_directory,                String, default: node[:magento_demo_builder][:samba][:share_list][:content_media_drop]
property :product_media_import_directory,   String, default: node[:magento_demo_builder][:samba][:share_list][:product_media_drop]
property :favicon_directory,                String, default: node[:magento_demo_builder][:non_samba][:media_drops][:favicon_drop]
property :logo_directory,                   String, default: node[:magento_demo_builder][:non_samba][:media_drops][:logo_drop]

action :remove_data do
    demo_shell_data_path = "#{new_resource.web_root}/#{new_resource.demo_shell_directory}/#{new_resource.demo_shell_fixtures_directory}"

    execute "Remove existing data files" do
        command "rm -rf #{demo_shell_data_path}/*"
        only_if { ::Dir.exist?(demo_shell_data_path) }
    end
end

action :remove_data_patches do
    demo_shell_data_path = "#{new_resource.web_root}/#{new_resource.demo_shell_directory}/#{new_resource.demo_shell_fixtures_directory}"

    ruby_block "Remove existing data patch" do
        block do
            DatabaseHelper.remove_data_patch(
                new_resource.patch_class, 
                new_resource.db_user, 
                new_resource.db_password, 
                new_resource.db_name
            )
        end
        only_if {
            ::Dir.exist?(demo_shell_data_path) ||
            DatabaseHelper.patch_exists(new_resource.patch_class, new_resource.db_user, new_resource.db_password, new_resource.db_name)
        }
    end
end

action :remove_media do
    [
        new_resource.wysiwyg_directory, 
        new_resource.product_media_import_directory,
        new_resource.favicon_directory,
        new_resource.logo_directory
    ].each do |path|
        execute "Remove existing media from #{path}" do
            command "rm -rf #{path}/*"
            not_if {
                new_resource.wysiwyg_directory.empty? ||
                new_resource.product_media_import_directory.empty? ||
                new_resource.favicon_directory.empty? ||
                new_resource.logo_directory.empty?
            }
            only_if {
                ::Dir.exist?(new_resource.wysiwyg_directory) &&
                ::Dir.exist?(new_resource.product_media_import_directory) &&
                ::Dir.exist?(new_resource.favicon_directory) &&
                ::Dir.exist?(new_resource.logo_directory)
            }
        end
    end
end

action :install_data do 
    demo_shell_data_path = "#{new_resource.web_root}/#{new_resource.demo_shell_directory}/#{new_resource.demo_shell_fixtures_directory}"

    execute "Copy data files into place" do
        command "cp -R #{new_resource.chef_data_files_path}/* #{demo_shell_data_path}"
        only_if { ::Dir.exist?(demo_shell_data_path) }
    end

    execute "Update data file permissions" do
        command "chmod -R 777 #{demo_shell_data_path}/* && chown -R #{new_resource.user}:#{new_resource.group} #{demo_shell_data_path}/*"
        only_if { ::Dir.exist?(demo_shell_data_path) }
    end
end

action :add_media do
    ::Dir["#{new_resource.chef_content_media_path}/*"].each do |media|
        execute "Copy content media into place" do
            command "cp -R #{media} #{new_resource.wysiwyg_directory}"
            only_if { ::Dir.exist?(new_resource.wysiwyg_directory) }
        end
    end

    ::Dir["#{new_resource.chef_product_media_path}/*"].each do |media|
        execute "Copy product media into place" do
            command "cp -R #{media} #{new_resource.product_media_import_directory}"
            only_if { ::Dir.exist?(new_resource.product_media_import_directory) }
        end
    end

    ::Dir["#{new_resource.chef_favicon_media_path}/*"].each do |media|
        execute "Copy favicon into place" do
            command "cp -R #{media} #{new_resource.web_root}/#{new_resource.favicon_directory}"
            only_if { ::Dir.exist?("#{new_resource.web_root}/#{new_resource.favicon_directory}") }
        end
    end

    ::Dir["#{new_resource.chef_logo_media_path}/*"].each do |media|
        execute "Copy logo into place" do
            command "cp -R #{media} #{new_resource.web_root}/#{new_resource.logo_directory}"
            only_if { ::Dir.exist?("#{new_resource.web_root}/#{new_resource.logo_directory}") }
        end
    end
end

action :add_patches do
    ::Dir["#{new_resource.chef_patches_path}/*"].each do |patch|
        execute "Copy #{patch} into patches holding area" do
            command "cp #{patch} #{new_resource.patches_holding_area}"
        end
    end
end