#
# Cookbook:: magento_restore
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_restore][:init][:user]
group = node[:magento_restore][:init][:user]
build_action = node[:magento_restore][:magento][:build][:action]
restore_mode = node[:magento_restore][:mode]
restore_source = node[:magento_restore][:source]
restore_version = node[:magento_restore][:version]
web_root = node[:magento_restore][:nginx][:web_root]
restore_path = node[:magento_restore][:restore_path]
backup_holding_area = node[:magento_restore][:holding_area]

if build_action == 'restore'
	directory 'Backup holding area' do
		path backup_holding_area
		user user
		group group
		not_if { ::Dir.exist?(backup_holding_area) }
	end

	magento_restore 'Remove cached backup files' do
		action :remove_backup_files
		source_path restore_path
		not_if { restore_source.empty? || restore_version.empty? }
	end

	magento_restore 'Download the remote backup' do
		action :download_remote_backup
		destination_path restore_path
		not_if { restore_source.empty? || restore_version.empty? }
	end

	magento_restore 'Extract backup archive' do
		action :extract_backup_archive
		source_path restore_path
		destination_path restore_path
	end

	magento_restore 'Restore backup' do
		action :restore_backups
		source_path restore_path
		destination_path web_root
	end
end
