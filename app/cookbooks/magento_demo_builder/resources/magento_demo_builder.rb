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
property :wysiwyg_directory,                String, default: node[:magento_demo_builder][:samba][:share_list][:content_media_drop]
property :product_media_import_directory,   String, default: node[:magento_demo_builder][:samba][:share_list][:product_media_drop]

action :install_data do 
    data_files = ::Dir["#{new_resource.chef_data_files_path}/*.csv"].map{|filename| filename.sub("#{new_resource.chef_data_files_path}/", "") }
    demo_shell_data_path = "#{new_resource.web_root}/#{new_resource.demo_shell_directory}/#{new_resource.demo_shell_fixtures_directory}"
    
    data_files.each do |file|
        cookbook_file "#{demo_shell_data_path}/#{file}" do
            source "data/#{file}"
            owner new_resource.user
            group new_resource.group
            mode "755"
            not_if { data_files.empty? }
            only_if { ::Dir.exist?(demo_shell_data_path) }
        end
    end
end

action :refresh_data do
    data_files = ::Dir["#{new_resource.chef_data_files_path}/*.csv"].map{|filename| filename.sub("#{new_resource.chef_data_files_path}/", "") }
    demo_shell_data_path = "#{new_resource.web_root}/#{new_resource.demo_shell_directory}/#{new_resource.demo_shell_fixtures_directory}"

    execute "Remove existing data files" do
        command "rm -rf #{demo_shell_data_path}/*"
        not_if { data_files.empty? }
        only_if { ::Dir.exist?(demo_shell_data_path) }
    end

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
            !data_files.empty? ||
            ::Dir.exist?(demo_shell_data_path) ||
            DatabaseHelper.patch_exists(new_resource.patch_class, new_resource.db_user, new_resource.db_password, new_resource.db_name)
        }
    end
end

action :remove_media do
    [new_resource.wysiwyg_directory, new_resource.product_media_import_directory].each do |path|
        execute "Remove existing media from #{path}" do
            command "rm -rf #{path}/*"
            not_if {
                new_resource.wysiwyg_directory.empty? ||
                new_resource.product_media_import_directory.empty?
            }
            only_if {
                ::Dir.exist?(new_resource.wysiwyg_directory) &&
                ::Dir.exist?(new_resource.product_media_import_directory)
            }
        end
    end
end

action :add_media do
    ::Dir["#{new_resource.chef_content_media_path}/*"].each do |media|
        print "Content media path: #{new_resource.chef_content_media_path}"
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
end

action :add_patches do
    ::Dir["#{new_resource.chef_patches_path}/*"].each do |patch|
        execute "Copy #{patch} into patches holding area" do
            command "cp #{patch} #{new_resource.patches_holding_area}"
        end
    end
end