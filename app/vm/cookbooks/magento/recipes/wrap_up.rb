#
# Cookbook:: magento
# Recipe:: wrap_up
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:init][:user]
web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]
warm_cache = node[:magento][:build][:hooks][:warm_cache]
enable_media_gallery = node[:magento][:build][:hooks][:enable_media_gallery]
commands = node[:magento][:build][:hooks][:commands]
vm_cli_commands = MagentoHelper.build_command_list(:vm_cli)
magento_cli_commands = MagentoHelper.build_command_list(:magento_cli)
csc_options = node[:magento][:csc_options]
maintenance_mode_flag = "#{web_root}/var/.maintenance.flag"
crontab = "/var/spool/cron/crontabs/#{user}"

csc_options.each do |key, value|
	next if value.empty? || %w[key_path production_private_key].include?(key)

	path = key.include?('api') ? 'services_connector_integration' : 'services_id'
	magento_cli "Configuring Commerce Services Connector setting : #{key}" do
		action :config_set
		config_path "services_connector/#{path}/#{key}"
		config_value value
	end
end

unless csc_options[:production_private_key].nil?
	path =
		'services_connector/services_connector_integration/production_private_key'
	query =
		"INSERT INTO core_config_data (path, value) VALUES('#{path}', '#{csc_options[:production_private_key]}') ON DUPLICATE KEY UPDATE path='#{path}', value='#{csc_options[:production_private_key]}'"
	mysql 'Insert commerce services production key' do
		action :run_query
		db_query query
		not_if do
			csc_options[:production_api_key].empty? &&
				csc_options[:project_id].empty? && csc_options[:environment_id].empty?
		end
	end
end

if enable_media_gallery
	media_gallery_commands =
		"config:set system/media_gallery/enabled #{ValueHelper.process_value(enable_media_gallery)}"
	media_gallery_commands = [media_gallery_commands, 'media-gallery:sync']
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

magento_cli 'Deploy static content after data pack installation' do
	action :deploy_static_content
end

if %w[install force_install reinstall restore].include?(build_action)
	magento_cli 'Set indexers to On Schedule mode' do
		action %i[set_indexer_mode]
	end

	magento_cli 'Start consumers' do
		action :start_consumers
	end
end

if %w[install force_install reinstall restore update_all update_app].include?(
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

if !warm_cache.nil? && warm_cache
	vm_cli 'Running the warm cache hook' do
		action :run
		command_list 'warm-cache'
	end
end
