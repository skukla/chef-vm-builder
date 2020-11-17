#
# Cookbook:: magento_restore
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
group = node[:magento][:init][:user]
web_root = node[:magento][:init][:web_root]
backup_holding_area = node[:magento_restore][:holding_area]
restore_path = node[:magento_restore][:restore_path]
backup_holding_area = node[:magento_restore][:holding_area]
apply_deploy_mode = node[:magento][:build][:deploy_mode][:apply]

mysql "Create the database" do
    action :create_database
end

directory "Backup holding area" do
    path backup_holding_area
    user user
    group group
    not_if { ::Dir.exist?(backup_holding_area) }
end

backup_files = Hash.new
["code", "media", "db"].each do |type|
    backup_files[type.to_sym] = Dir["#{restore_path}/*"].find{ |file| file.include?(type) }
end

unless backup_files[:code].nil? || backup_files[:media].nil? || backup_files[:db].nil?
    backup_files.slice(:code, :media).each do |key, file|
        magento_restore "Restore the #{key} backup from #{file}" do
            action :restore_backup
            source file
            destination web_root
        end
    end
    mysql "Restore the database" do
        action :restore_dump
        db_dump backup_files[:db]
    end
end

composer "Install the codebase" do
    action :install
end

magento_app "Upgrade Magento database" do
    action :db_upgrade
end

magento_app "Re-compile dependency injections and deploy static content" do
    action [:di_compile, :deploy_static_content]
    not_if { apply_deploy_mode }
end
