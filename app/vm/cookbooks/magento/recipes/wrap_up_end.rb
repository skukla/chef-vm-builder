# Cookbook:: magento
# Recipe:: wrap_up_end
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

user = node[:magento][:init][:user]
web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]
restore_mode = node[:magento][:restore][:mode]
merge_restore = (build_action == 'restore' && restore_mode == 'merge')
warm_cache = node[:magento][:build][:hooks][:warm_cache]
maintenance_mode_flag = "#{web_root}/var/.maintenance.flag"
crontab = "/var/spool/cron/crontabs/#{user}"
commands = node[:magento][:build][:hooks][:commands]
magento_cli_commands = MagentoHelper.build_command_list(:magento_cli)
vm_cli_commands = MagentoHelper.build_command_list(:vm_cli)
backup = node[:magento][:build][:hooks][:backup]

if %w[install force_install update_all update_data].include?(build_action) ||
		merge_restore
	magento_cli 'Deploy static content for data packs' do
		action :deploy_static_content
	end
end

if %w[install force_install reinstall restore].include?(build_action)
	magento_cli 'Set indexers to On Schedule mode' do
		action %i[set_indexer_mode]
	end
end

if %w[install force_install reinstall update_all update_app restore].include?(
		build_action,
   )
	magento_cli 'Enable cron' do
		action :enable_cron
		not_if { ::File.exist?(crontab) }
	end
end

magento_cli 'Reset indexers, reindex, and clean cache' do
	action %i[reset_indexers reindex clean_cache]
end

magento_app 'Set permissions' do
	action :set_permissions
	remove_generated false
end

magento_cli 'Disable maintenance mode' do
	action :disable_maintenance_mode
	only_if { ::File.exist?(maintenance_mode_flag) }
end

if %w[install force_install reinstall update_all update_app restore].include?(
		build_action,
   )
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

	if !backup.nil? && backup
		vm_cli 'Running the backup hook' do
			action :run
			command_list %w[backup export-backup remove-backup]
		end
	end

	if !warm_cache.nil? && warm_cache
		vm_cli 'Running the warm cache hook' do
			action :run
			command_list 'warm-cache'
		end
	end
end

ruby_block 'Displaying URLs' do
	block { MessageHelper.displayUrls }
	sensitive true
end
