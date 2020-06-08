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

magento_app "Set application mode" do
    action :set_application_mode
    not_if {
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install"
    }
    only_if { 
        apply_deploy_mode 
    }
end

magento_app "Enable cron" do
    action :enable_cron
    not_if { 
        ::File.exist?("/var/spool/cron/crontabs/#{user}") 
    }
end

magento_app "Set indexers to On Schedule mode" do
    action :set_indexer_mode
    not_if {
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install"
    }
    only_if { 
        build_action == "reinstall" || build_action == "force_install"
    }
end

magento_app "Reset indexers" do
    action :reset_indexers
    not_if {
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install"
    }
end

magento_app "Reindex" do
    action :reindex
    not_if {
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install"
    }
end

magento_app "Clean config and full page cache" do
    action :clean_cache
    cache_types ["config", "full_page"]
    not_if {
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install"
    }
end

magento_app "Set final permissions" do
    action :set_permissions
    not_if {
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == "install"
    }
end

magento_app "Set first run flag" do
    action :set_first_run
    not_if {
        ::File.exist?("#{web_root}/var/.first-run-state.flag")
    }
end