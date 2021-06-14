#
# Cookbook:: magento
# Recipe:: wrap_up
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
custom_module_list = node[:magento][:custom_modules]
warm_cache = node[:magento][:build][:hooks][:warm_cache]
enable_media_gallery = node[:magento][:build][:hooks][:enable_media_gallery]
commands = node[:magento][:build][:hooks][:commands]
vm_cli_commands = commands.reject { |command| command.include?(':') }
magento_cli_commands = commands.select { |command| command.include?(':') }
csc_options = node[:magento][:csc_options]
production_private_key = node[:magento][:csc_options][:production_private_key].chomp
maintenance_mode_flag = "#{web_root}/var/.maintenance.flag"

csc_options.each do |key, value|
  next if %w[key_path production_private_key].include?(key) || value.empty?

  path = key.include?('api') ? 'services_connector_integration' : 'services_id'
  magento_cli "Configuring Commerce Services Connector setting : #{key}" do
    action :config_set
    config_path "services_connector/#{path}/#{key}"
    config_value value
  end
end

unless production_private_key.empty?
  path = 'services_connector/services_connector_integration/production_private_key'
  query = "INSERT INTO core_config_data (path, value) VALUES('#{path}', '#{production_private_key}') ON DUPLICATE KEY UPDATE path='#{path}', value='#{production_private_key}'"
  mysql 'Insert commerce services production key' do
    action :run_query
    db_query query
    only_if do
      !csc_options[:production_api_key].empty? &&
        !csc_options[:project_id].empty? &&
        !csc_options[:environment_id].empty?
    end
  end
end

if enable_media_gallery
  media_gallery_commands = "config:set system/media_gallery/enabled #{ValueHelper.process_value(enable_media_gallery)}"
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

magento_app 'Deploy static content after data pack installation' do
  action %i[deploy_static_content]
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
