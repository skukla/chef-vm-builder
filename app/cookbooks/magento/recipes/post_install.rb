#
# Cookbook:: magento
# Recipe:: post_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
web_root = node[:magento][:init][:web_root]
build_action = node[:magento][:build][:action]
apply_deploy_mode = node[:magento][:build][:deploy_mode][:apply]

magento_app "Set application mode" do
    action :set_application_mode
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install" }
    only_if { apply_deploy_mode }
end

magento_app "Enable cron" do
    action :enable_cron
    not_if { 
        ::File.exist?("/var/spool/cron/crontabs/#{user}") ||
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install"
    }
end

magento_app "Start consumers" do
    action :start_consumers
    only_if { !::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "update" }
end

magento_app "Set indexers to On Schedule mode" do
    action :set_indexer_mode
    only_if { !::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "update" }
end

magento_app "Reset indexers" do
    action :reset_indexers
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "update" }
end

magento_app "Reindex" do
    action :reindex
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "update" }
end

magento_app "Clean config and full page cache" do
    action :clean_cache
    cache_types ["config", "full_page"]
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "update" }
end

samba "Create Magento samba shares" do
    action :create_magento_shares
end

magento_app "Set final permissions" do
    action :set_permissions
    remove_generated false
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != "update" }
end

magento_app "Set first run flag" do
    action :set_first_run
    not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") }
end
