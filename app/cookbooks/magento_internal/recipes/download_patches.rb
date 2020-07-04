#
# Cookbook:: magento_internal
# Recipe:: download_patches
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_internal][:init][:user]
group = node[:magento_internal][:init][:user]
patches_repository = node[:magento_internal][:patches][:repository_url]
patches_holding_area = node[:magento_internal][:patches][:holding_area]
magento_version = node[:magento_internal][:magento][:version]

git 'PMET patches' do
    repository "#{patches_repository}"
    revision "pmet-#{magento_version}-ref"
    destination "#{patches_holding_area}"
    action :sync
    user "#{user}"
    group "#{group}"
end