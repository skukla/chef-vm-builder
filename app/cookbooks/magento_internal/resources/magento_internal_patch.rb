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
property :configuration,            Hash

action :clone_internal_repository do
    git 'Downlaod internal patches' do
        repository "#{new_resource.configuration[:patches_repository]}"
        revision "#{new_resource.configuration[:patches_branch]}"
        destination "#{new_resource.configuration[:patches_holding_area]}"
        enable_checkout new_resource.configuration[:patches_branch] == "master" ? false : true
        action :sync
        user "#{new_resource.user}"
        group "#{new_resource.group}"
    end
end