#
# Cookbook:: magento_internal
# Resource:: magento_internal_patch
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_internal_patch
provides :magento_internal_patch

property :name,                     String, name_property: true
property :user,                     String, default: node[:magento_internal][:init][:user]
property :group,                    String, default: node[:magento_internal][:init][:user]
property :web_root,                 String, default: node[:magento_internal][:init][:web_root]
property :magento_version,          String, default: node[:magento_internal][:magento][:version]
property :patches_repository_url,   String, default: node[:magento_internal][:patches][:repository_url]
property :patches_branch,           String, default: node[:magento_internal][:branch]
property :patches_holding_area,     String, default: node[:magento_internal][:patches][:holding_area]

action :clone_internal_repository do
    git "Downlaod internal patches" do
        repository new_resource.patches_repository_url
        revision new_resource.patches_branch
        destination new_resource.patches_holding_area
        enable_checkout new_resource.patches_branch == "master" ? false : true
        action :sync
        user new_resource.user
        group new_resource.group
    end
end