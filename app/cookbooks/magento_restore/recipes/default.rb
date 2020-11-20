#
# Cookbook:: magento_restore
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
group = node[:magento][:init][:user]
web_root = node[:magento][:init][:web_root]
unsecure_base_url = node[:magento][:settings][:unsecure_base_url]
secure_base_url = node[:magento][:settings][:secure_base_url]
restore_path = node[:magento_restore][:restore_path]
backup_holding_area = node[:magento_restore][:holding_area]
apply_deploy_mode = node[:magento][:build][:deploy_mode][:apply]
backup_url = node[:magento_restore][:remote_backup_data][:download_url]
use_secure_frontend = node[:magento_restore][:magento][:settings][:use_secure_frontend]
use_secure_admin = node[:magento_restore][:magento][:settings][:use_secure_admin]

mysql "Create the database" do
    action :create_database
end

directory "Backup holding area" do
    path backup_holding_area
    user user
    group group
    not_if { ::Dir.exist?(backup_holding_area) }
end

magento_restore "Download the backup zip file" do
    action :download_remote_backup
    source backup_url
    destination restore_path
    not_if { backup_url.empty? || backup_url.nil? }
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
    only_if { ::File.exist?("#{web_root}/composer.json") }
end

magento_app "Upgrade Magento database" do
    action :db_upgrade
    not_if { ::Dir.empty?(restore_path) || ::Dir.empty?(web_root) }
end

magento_app "Re-compile dependency injections and deploy static content" do
    action [:di_compile, :deploy_static_content]
    not_if { apply_deploy_mode || ::Dir.empty?(restore_path) || ::Dir.empty?(web_root) }
end

magento_cli "Configure unsecure base URL" do
    action :config_set
    config_path "web/unsecure/base_url"
    config_value unsecure_base_url
    not_if { use_secure_frontend.to_s == "1" || use_secure_admin.to_s == "1" }
end

magento_cli "Configure secure base URL" do
    action :config_set
    config_path "web/secure/base_url"
    config_value secure_base_url
    only_if { use_secure_frontend.to_s == "1" || use_secure_admin.to_s == "1" }
end