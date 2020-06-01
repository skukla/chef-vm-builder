#
# Cookbook:: magento_internal
# Recipe:: download_patches
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_internal][:user]
group = node[:magento_internal][:user]
web_root = node[:magento_internal][:web_root]
patches_repository = node[:magento_internal][:patches][:repository_url]
patches_holding_area = node[:magento_internal][:patches][:holding_area]
magento_version = node[:magento_internal][:magento_version]

git 'PMET patches' do
    repository "#{patches_repository}"
    revision "pmet-#{magento_version}-ref"
    destination "#{patches_holding_area}"
    action :sync
    user "#{user}"
    group "#{group}"
end