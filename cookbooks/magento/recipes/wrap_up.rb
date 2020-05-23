#
# Cookbook:: magento
# Recipe:: wrap_up
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]
build_action = node[:magento][:installation][:build][:action]
apply_deploy_mode = node[:magento][:installation][:build][:deploy_mode][:apply]

if File.exist?("#{web_root}/app/etc/config.php")
    magento_cli "Set application mode" do
        action :set_application_mode
        only_if { apply_deploy_mode }
    end

    magento_cli "Enable cron" do
        action :enable_cron
        not_if { "su #{user} -c 'crontab -l'" }
    end

    magento_cli "Set indexers to On Schedule mode" do
        action :set_indexer_mode
        only_if { build_action == "install" }
    end

    include_recipe "magento_configuration::create_image_drop" if build_action == "install"

    magento_app "Set final permissions" do
        action :set_permissions
    end

    magento_cli "Reindex" do
        action :reindex
    end

    magento_cli "Clean config and full page cache" do
        action :clean_cache
    end
end
