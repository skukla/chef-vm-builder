# Cookbook:: magento_restore
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento_restore][:restore_path] = '/var/chef/cache/cookbooks/magento_restore/files/default'
default[:magento_restore][:holding_area] = '/var/www/backups'
default[:magento_restore][:local_files][:zip_file] = ''
default[:magento_restore][:local_files][:code_file] = ''
default[:magento_restore][:local_files][:database_file] = ''
default[:magento_restore][:local_files][:media_file] = ''
default[:magento_restore][:remote_backup_data][:version] = ''
default[:magento_restore][:remote_backup_data][:repository_url] = 'github.com/skukla/magento-backups.git'
