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
property :configuration,            Hash

action :remove_holding_area do
    execute "Remove patches holding area" do
        command "rm -rf #{new_resource.configuration[:patches_holding_area]}"
        only_if { Dir.exist?("#{new_resource.configuration[:patches_holding_area]}") }
    end
end

action :remove_from_web_root do
    execute "Remove patches from web root" do
        command "sudo rm -rf #{new_resource.web_root}/#{new_resource.configuration[:directory_in_codebase]}"
        only_if { Dir.exist?("#{new_resource.web_root}/#{new_resource.configuration[:directory_in_codebase]}") }
    end
end

action :clone_custom_repository do
    git 'Downlaod custom patches' do
        repository "#{new_resource.configuration[:patches_repository]}"
        revision "#{new_resource.configuration[:patches_branch]}"
        destination "#{new_resource.configuration[:patches_holding_area]}"
        enable_checkout new_resource.configuration[:patches_branch] == "master" ? false : true
        action :sync
        user "#{new_resource.user}"
        group "#{new_resource.group}"
    end
end

action :filter_directory do
    execute "Pull out patches from repository" do
        command "cd #{new_resource.configuration[:patches_holding_area]} && 
        git filter-branch --subdirectory-filter #{new_resource.configuration[:directory_in_repository]}"
    end
end

action :move_into_web_root do
    execute "Move patches into web root" do
        command "mv #{new_resource.configuration[:patches_holding_area]} #{new_resource.web_root}/#{new_resource.configuration[:directory_in_codebase]}"
        only_if { ::Dir.exist?("#{new_resource.configuration[:patches_holding_area]}") }
    end
end

action :build_patch_file do
    ruby_block "Build patch file" do
        block do
            PatchHelper.build_patch_file(
                "#{new_resource.web_root}/#{new_resource.configuration[:directory_in_codebase]}", 
                "#{new_resource.web_root}/#{new_resource.configuration[:directory_in_codebase]}/#{new_resource.configuration[:patches_file]}"
            )
        end
    end
end