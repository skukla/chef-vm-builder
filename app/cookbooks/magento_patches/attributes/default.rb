# Cookbook:: magento_patches
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento_patches][:chef_files][:path] = '/var/chef/cache/cookbooks/magento_patches/files/default'
default[:magento_patches][:apply] = false
default[:magento_patches][:repository_url] = 'https://github.com/PMET-public/magento-cloud.git'
default[:magento_patches][:repository_directory] = 'm2-hotfixes'
default[:magento_patches][:codebase_directory] = 'm2-hotfixes'
default[:magento_patches][:holding_area] = '/var/www/patches'
default[:magento_patches][:vendor_directory] = 'magento/magento-cloud-patches'
