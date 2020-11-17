#
# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
build_action = node[:magento][:build][:action]

php "Switch PHP user to #{user}" do
    action :set_user
    php_user user
end

magento_app "Clear the cron schedule" do
    action :clear_cron_schedule
    only_if { 
        ::File.exist?("#{web_root}/var/.first-run-state.flag") && 
        ::File.exist?("/var/spool/cron/crontabs/#{user}") && 
        build_action != "install"  
    }
end

magento_app "Set auth.json credentials" do
    action :set_auth_credentials
end