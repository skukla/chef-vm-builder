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
property :restore_path,             String, default: node[:magento_restore][:restore_path]
property :source,                   String
property :destination,              String
property :file_list,                Array

action :transfer_backup_files do
    Dir["#{new_resource.source}/*"].each do |file|
        [".tgz", ".sql"].any? do |extension| 
            if file.include?(extension)
                execute new_resource.name do
                    command "cp #{file} #{new_resource.destination}"
                end
            end
        end
    end
end

action :unzip_backup do
    archive_file "Unzipping #{new_resource.source}" do
        path new_resource.source
        destination new_resource.destination
        owner new_resource.user
        group new_resource.group
        overwrite :auto
        only_if { ::File.exist?(new_resource.source) }
    end
end

action :restore_backup do
    archive_file "Restore the backup from #{new_resource.source}" do
        path new_resource.source
        destination new_resource.destination
        owner new_resource.user
        group new_resource.group
        overwrite :auto
        only_if { ::File.exist?(new_resource.source) }
    end
end

action :remove_backup_files do
    execute "Remove backup files from #{new_resource.source}" do
        command "rm -rf #{new_resource.source}/*"
        only_if { ::Dir.exist?(new_resource.source) }
        not_if { ::Dir.empty?(new_resource.source) }
    end
end