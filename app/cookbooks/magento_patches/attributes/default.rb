#
# Cookbook:: magento_patches
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:magento_patches][:apply] = false
default[:magento_patches][:repository_url] = 'https://github.com/PMET-public/magento-cloud.git'
default[:magento_patches][:repository_directory] = 'm2-hotfixes'
default[:magento_patches][:branch] = 'master'
default[:magento_patches][:codebase_directory] = 'm2-hotfixes'
default[:magento_patches][:holding_area] = '/var/www/patches'
default[:magento_patches][:patches_file] = 'patches.json'
