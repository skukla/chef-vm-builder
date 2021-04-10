#
# Cookbook:: magento
# Recipe:: post_refresh
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
crontab = "/var/spool/cron/crontabs/#{user}"

magento_app 'Enable cron' do
  action :enable_cron
  not_if { ::File.exist?(crontab) }
end

magento_app 'Reset indexers, reindex, clean cache, and set permissions' do
  action %i[reset_indexers reindex clean_cache set_permissions]
  remove_generated false
end
