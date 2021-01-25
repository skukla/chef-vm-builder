#
# Cookbook:: magento_restore
# Resource:: magento
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :magento_restore
provides :magento_restore

property :name,                     String, name_property: true
property :user,                     String, default: node[:magento_restore][:init][:user]
property :group,                    String, default: node[:magento_restore][:init][:user]
property :web_root,                 String, default: node[:magento_restore][:init][:web_root]
property :restore_path,             String, default: node[:magento_restore][:restore_path]
property :source,                   [String, Array]
property :destination,              String
property :backup_version,           String, default: node[:magento_restore][:remote_backup_data][:version]
property :backup_repository_url,    String, default: node[:magento_restore][:remote_backup_data][:repository_url]
property :github_token,             String, default: node[:magento_restore][:composer][:github_token]
property :db_user,                  String, default: node[:magento_restore][:mysql][:db_user]
property :db_password,              String, default: node[:magento_restore][:mysql][:db_password]
property :db_name,                  String, default: node[:magento_restore][:mysql][:db_name]

action :transfer_backup_files do
  Dir["#{new_resource.source}/*"].each do |file|
    ['.tgz', '.sql'].any? do |extension|
      if file.include?(extension)
        execute new_resource.name do
          command "cp #{file} #{new_resource.destination}"
        end
      end
    end
  end
end

action :download_remote_backup do
  git "#{new_resource.restore_path}/backup" do
    action :checkout
    repository "https://#{new_resource.github_token}@#{new_resource.backup_repository_url}"
    revision new_resource.backup_version
  end

  %w[code media db].each do |entity|
    execute "Stich #{entity} backup pieces together" do
      command "cat ./backup/#{entity}/part* > ./backup/#{new_resource.backup_version}-#{entity}.tgz"
      only_if { Dir.exist?("#{new_resource.restore_path}/backup/#{entity}") }
      cwd new_resource.restore_path
    end
  end

  execute 'Move backup files into place' do
    command 'mv ./backup/*.tgz .'
    cwd new_resource.restore_path
    only_if { Dir.exist?("#{new_resource.restore_path}/backup") }
    not_if { Dir.empty?("#{new_resource.restore_path}/backup") }
  end

  execute 'Clean up extra backup folders' do
    command 'rm -rf ./backup'
    cwd new_resource.restore_path
    only_if { Dir.exist?("#{new_resource.restore_path}/backup") }
  end
end

action :extract_backup_archive do
  Dir.entries(new_resource.source).each do |file|
    next unless "#{new_resource.source}/#{file}".include?('.zip')

    archive_file "Unzipping #{new_resource.source}/#{file}" do
      path "#{new_resource.source}/#{file}"
      destination new_resource.destination
      owner new_resource.user
      group new_resource.group
      overwrite :auto
    end
  end
end

action :restore_backups do
  Dir.entries(new_resource.source).each do |file|
    %w[code media].any? do |type|
      if "#{new_resource.source}/#{file}".include?(type)
        archive_file "Restoring the #{type} backup from #{new_resource.source}/#{file}" do
          path "#{new_resource.source}/#{file}"
          destination new_resource.web_root
          owner new_resource.user
          group new_resource.group
          overwrite :auto
        end
      end
    end
    next unless file.include?('db')

    mysql "Restoring the database backup from #{new_resource.source}/#{file}" do
      action :restore_dump
      db_dump "#{new_resource.source}/#{file}"
    end
  end
end

action :remove_backup_files do
  execute "Remove backup files from #{new_resource.source}" do
    command 'rm -rf ..?* .[!.]* *'
    cwd new_resource.source
    only_if { ::Dir.exist?(new_resource.source) }
    not_if { ::Dir.empty?(new_resource.source) }
  end
end
