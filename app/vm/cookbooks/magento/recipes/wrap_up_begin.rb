# Cookbook:: magento
# Recipe:: wrap_up_begin
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]
restore_mode = node[:magento][:restore][:mode]
merge_restore = (build_action == 'restore' && restore_mode == 'merge')
separate_restore = (build_action == 'restore' && restore_mode == 'separate')
merge_restore = (build_action == 'restore' && restore_mode == 'merge')
csc_options = node[:magento][:csc_options]
enable_media_gallery = node[:magento][:build][:hooks][:enable_media_gallery]
commands = node[:magento][:build][:hooks][:commands]
magento_cli_commands = MagentoHelper.build_command_list(:magento_cli)
vm_cli_commands = MagentoHelper.build_command_list(:vm_cli)

if %w[install force_install reinstall update_all update_app].include?(
		build_action,
   ) || merge_restore
	csc_options.each do |key, value|
		next if value.empty? || %w[key_path production_private_key].include?(key)

		path =
			key.include?('api') ? 'services_connector_integration' : 'services_id'
		magento_cli "Configuring Commerce Services Connector setting : #{key}" do
			action :config_set
			config_path "services_connector/#{path}/#{key}"
			config_value value
			ignore_failure true
		end
	end

	if !csc_options[:production_private_key].nil? &&
			!csc_options[:production_api_key].empty?
		path =
			'services_connector/services_connector_integration/production_private_key'
		query =
			"INSERT INTO core_config_data (path, value) VALUES('#{path}', '#{csc_options[:production_private_key]}') ON DUPLICATE KEY UPDATE path='#{path}', value='#{csc_options[:production_private_key]}'"
		mysql 'Insert commerce services production key' do
			action :run_query
			db_query query
		end
	end
end

unless separate_restore
	if enable_media_gallery
		media_gallery_commands =
			"config:set system/media_gallery/enabled #{ValueHelper.process_value(enable_media_gallery)}"
		media_gallery_commands = [media_gallery_commands, 'media-gallery:sync']
		magento_cli 'Running the enable_media_gallery hook' do
			action :run
			command_list media_gallery_commands
		end
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
