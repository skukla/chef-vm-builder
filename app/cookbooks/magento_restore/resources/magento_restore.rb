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
property :db_user,                  String, default: node[:magento_restore][:mysql][:db_user]
property :db_password,              String, default: node[:magento_restore][:mysql][:db_password]
property :db_name,                  String, default: node[:magento_restore][:mysql][:db_name]

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

action :download_remote_backup do
    if new_resource.source.include?("dropbox")
        execute "Downloading the #{new_resource.backup_version} backup from #{new_resource.source}" do
            command "curl #{new_resource.source} -location --progress-bar --output #{new_resource.destination}/#{new_resource.backup_version}.zip"
        end
    elsif new_resource.source.include?("google")
        id = new_resource.source.sub("https://drive.google.com/file/d/","").sub("/view?usp=sharing", "")
        bash "Downloading the #{new_resource.backup_version} backup from #{new_resource.source}" do
            code <<-EOH
                function download-google() {
                    echo "https://drive.google.com/uc?export=download&id=$1"
                    mkdir -p .tmp
                    curl -c .tmp/$1cookies "https://drive.google.com/uc?export=download&id=$1" > .tmp/$1intermezzo.html;
                    code=$(egrep -o "confirm=(.+)&amp;id=" .tmp/$1intermezzo.html | cut -d"=" -f2 | cut -d"&" -f1)
                    curl --location --cookie .tmp/$1cookies --progress-bar "https://drive.google.com/uc?export=download&confirm=$code&id=$1" > $2;
                }
                download-google #{id} #{new_resource.destination}/#{new_resource.backup_version}.zip
            EOH
            cwd new_resource.web_root
        end
    end
end

action :extract_backup_archive do
    Dir.entries(new_resource.source).each do |file|
        if "#{new_resource.source}/#{file}".include?(".zip")
            archive_file "Unzipping #{new_resource.source}/#{file}" do
                path "#{new_resource.source}/#{file}"
                destination new_resource.destination
                owner new_resource.user
                group new_resource.group
                overwrite :auto
            end
        end
    end
end

action :restore_backups do
    Dir.entries(new_resource.source).each do |file|
        ["code", "media"].any? do |type|
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
        if file.include?("db")
            mysql "Restoring the database backup from #{new_resource.source}/#{file}" do
                action :restore_dump
                db_dump "#{new_resource.source}/#{file}"
            end
        end
    end
end

action :remove_backup_files do
    execute "Remove backup files from #{new_resource.source}" do
        command "rm -rf ..?* .[!.]* *"
        cwd new_resource.source
        only_if { ::Dir.exist?(new_resource.source) }
        not_if { ::Dir.empty?(new_resource.source) }
    end
end