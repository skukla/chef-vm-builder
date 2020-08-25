#
# Cookbook:: magento_patches
# Resource:: magento_patch
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_patch
provides :magento_patch

property :name,                     String, name_property: true
property :user,                     String, default: node[:magento_patches][:init][:user]
property :group,                    String, default: node[:magento_patches][:init][:user]
property :web_root,                 String, default: node[:magento_patches][:init][:web_root]
property :magento_version,          String, default: node[:magento_patches][:magento][:version]
property :composer_file,            String, default: node[:magento_patches][:composer][:file]
property :patches_repository_url,   String, default: node[:magento_patches][:repository_url]
property :patches_branch,           String, default: node[:magento_patches][:branch]
property :directory_in_repository,  String, default: node[:magento_patches][:repository_directory]
property :directory_in_codebase,    String, default: node[:magento_patches][:codebase_directory]
property :patches_holding_area,     String, default: node[:magento_patches][:holding_area]
property :patches_file,             String, default: node[:magento_patches][:patches_file]

action :remove_holding_area do
    execute "Remove patches holding area" do
        command "rm -rf #{new_resource.patches_holding_area}"
        only_if { ::Dir.exist?(new_resource.patches_holding_area) }
    end
end

action :remove_from_web_root do
    execute "Remove patches from web root" do
        command "rm -rf #{new_resource.web_root}/#{new_resource.directory_in_codebase}"
        only_if { ::Dir.exist?("#{new_resource.web_root}/#{new_resource.directory_in_codebase}") }
    end
end

action :set_permissions do
    directory "/var/www" do
        mode "775"
    end
end

action :clone_patches_repository do
    git "Downlaod patches" do
        repository new_resource.patches_repository_url
        revision new_resource.patches_branch
        destination new_resource.patches_holding_area
        enable_checkout new_resource.patches_branch == "master" ? false : true
        action :sync
        user new_resource.user
        group new_resource.group
    end
end

action :filter_directory do
    execute "Pull out patches from repository" do
        command "cd #{new_resource.patches_holding_area} && 
        git filter-branch --subdirectory-filter #{new_resource.directory_in_repository}"
    end
end

action :move_into_web_root do
    execute "Move patches into web root" do
        command "mv #{new_resource.patches_holding_area} #{new_resource.web_root}/#{new_resource.directory_in_codebase}"
        only_if { ::Dir.exist?(new_resource.patches_holding_area) }
    end
end

action :build_patch_file do
    ruby_block "Build patch file" do
        block do
            PatchHelper.build_patch_file(
                "#{new_resource.web_root}/#{new_resource.directory_in_codebase}", 
                "#{new_resource.web_root}/#{new_resource.directory_in_codebase}/#{new_resource.patches_file}"
            )
        end
    end
end