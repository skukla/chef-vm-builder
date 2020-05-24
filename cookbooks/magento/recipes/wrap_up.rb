#
# Cookbook:: magento
# Recipe:: wrap_up
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]
build_action = node[:magento][:installation][:build][:action]
force_install = node[:magento][:installation][:build][:force_install]
apply_deploy_mode = node[:magento][:installation][:build][:deploy_mode][:apply]


magento_cli "Set application mode" do
    action :set_application_mode
    only_if { ::File.exist?("#{web_root}/app/etc/config.php") && apply_deploy_mode }
end

magento_cli "Enable cron" do
    action :enable_cron
    only_if { ::File.exist?("#{web_root}/app/etc/config.php") && !::File.exist?("/var/spool/cron/crontabs/#{user}") }
end

magento_cli "Set indexers to On Schedule mode" do
    action :set_indexer_mode
    only_if { ::File.exist?("#{web_root}/app/etc/config.php") && build_action == "install" || force_install }
end

include_recipe "magento_configuration::create_image_drop" if File.exist?("#{web_root}/app/etc/config.php") && build_action == "install" || force_install

magento_app "Set final permissions" do
    action :set_permissions
    only_if { ::File.exist?("#{web_root}/app/etc/config.php") }
end

magento_cli "Reset indexers" do
    action :reset_indexers
    only_if { ::File.exist?("#{web_root}/app/etc/config.php") }
end

magento_cli "Reindex" do
    action :reindex
    only_if { ::File.exist?("#{web_root}/app/etc/config.php") }
end

magento_cli "Clean config and full page cache" do
    action :clean_cache
    cache_types ["config", "full_page"]
    only_if { ::File.exist?("#{web_root}/app/etc/config.php") }
end
