#
# Cookbook:: magento
# Recipe:: wrap_up
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
warm_cache = node[:magento][:build][:hooks][:warm_cache]
enable_media_gallery = node[:magento][:build][:hooks][:enable_media_gallery]
commands = node[:magento][:build][:hooks][:commands]
vm_cli_commands = commands.reject { |command| command.include?(':') }
magento_cli_commands = commands.select { |command| command.include?(':') }
maintenance_mode_flag = "#{web_root}/var/.maintenance.flag"

media_gallery_commands = "config:set system/media_gallery/enabled #{ValueHelper.process_value(enable_media_gallery)}"
media_gallery_commands = [media_gallery_commands, 'media-gallery:sync'] if enable_media_gallery

if enable_media_gallery
  magento_cli 'Running the enable_media_gallery hook' do
    action :run
    command_list media_gallery_commands
  end
end

if !commands.nil? && !commands.empty?
  magento_cli 'Running user Magento CLI hooks' do
    action :run
    command_list magento_cli_commands
  end

  vm_cli 'Running user VM CLI hooks' do
    action :run
    command_list vm_cli_commands
  end
end

magento_app 'Reset indexers, reindex, clean cache, and set permissions' do
  action %i[reset_indexers reindex clean_cache set_permissions]
  remove_generated false
end

magento_app 'Disable maintenance mode' do
  action :disable_maintenance_mode
  only_if { ::File.exist?(maintenance_mode_flag) }
end

if !warm_cache.nil? && warm_cache
  vm_cli 'Running the warm cache hook' do
    action :run
    command_list 'warm-cache'
  end
end
