#
# Cookbook:: magento_patches
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:magento_patches][:chef_files][:path] = '/var/chef/cache/cookbooks/magento_patches/files/default'
default[:magento_patches][:apply] = false
default[:magento_patches][:repository_url] = 'https://github.com/PMET-public/magento-cloud.git'
default[:magento_patches][:repository_directory] = 'm2-hotfixes'
default[:magento_patches][:codebase_directory] = 'm2-hotfixes'
default[:magento_patches][:holding_area] = '/var/www/patches'
default[:magento_patches][:vendor_directory] = 'magento/magento-cloud-patches'

include_attribute 'magento_patches::external'
version = node[:magento_patches][:magento][:version]
use_sample_data = node[:magento_patches][:magento][:sample_data]

if ValueHelper.process_value(use_sample_data).zero? && VersionHelper.check_version(version, '>=', '2.4.1')
  default[:magento_patches][:branch] = "pmet-#{VersionHelper.get_base_version(version)}-mc"
else
  default[:magento_patches][:branch] = "pmet-#{VersionHelper.get_base_version(version)}-ref"
end
