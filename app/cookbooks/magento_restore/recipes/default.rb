#
# Cookbook:: magento_restore
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
group = node[:magento][:init][:user]
web_root = node[:magento][:init][:web_root]
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

magento_restore "Extract backup zip file" do
    action :extract_backup_archive
    source restore_path
    destination restore_path
end

magento_restore "Restore backup" do
    action :restore_backups
    source restore_path
    destination web_root
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