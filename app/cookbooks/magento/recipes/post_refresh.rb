#
# Cookbook:: magento
# Recipe:: post_refresh
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
crontab = "/var/spool/cron/crontabs/#{user}"
enable_media_gallery = node[:magento][:build][:hooks][:enable_media_gallery]

magento_app 'Enable cron' do
  action :enable_cron
  not_if { ::File.exist?(crontab) }
end

if enable_media_gallery
  media_gallery_commands = "config:set system/media_gallery/enabled #{ValueHelper.process_value(enable_media_gallery)}"
  media_gallery_commands = [media_gallery_commands, 'media-gallery:sync']
  magento_cli 'Running the enable_media_gallery hook' do
    action :run
    command_list media_gallery_commands
  end
end

magento_app 'Reset indexers, reindex, clean cache, and set permissions' do
  action %i[reset_indexers reindex clean_cache set_permissions]
  remove_generated false
end
