# Cookbook:: magento_restore
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

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
  directory 'Creating backup holding area' do
    path backup_holding_area
    user user
    group group
    not_if { ::Dir.exist?(backup_holding_area) }
  end

  magento_restore 'Removing cached remote backup files' do
    action :remove_backup_files
    source_path restore_path
    not_if { restore_source.empty? || restore_version.empty? }
  end

  magento_restore 'Downloading the remote backup' do
    action :download_remote_backup
    destination_path restore_path
    not_if { restore_source.empty? || restore_version.empty? }
  end

  magento_restore 'Transferring backup files' do
    action :transfer_backup_files
    source_path restore_path
    destination_path backup_holding_area
    pattern %w[*.zip *.tgz *.sql]
  end

  magento_restore 'Extracting backup archive' do
    action :extract_backup_archive
    source_path backup_holding_area
    destination_path backup_holding_area
    pattern %w[*.zip]
  end

  magento_restore 'Extract application archive' do
    action :extract_backup_archive
    source_path backup_holding_area
    destination_path backup_holding_area
    pattern %w[app.zip]
  end

  magento_restore 'Restoring backup' do
    action :extract_backup_archive
    source_path backup_holding_area
    destination_path web_root
    pattern %w[*_code.tgz *_media.tgz]
  end

  directory 'Clearing content from the vendor directory' do
    path "#{web_root}/vendor"
    recursive true
    action :delete
    only_if { ::Dir.exist?("#{web_root}/vendor") }
    not_if { ::Dir.empty?("#{web_root}/vendor") }
  end
end
