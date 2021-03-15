#
# Cookbook:: magento
# Recipe:: wrap_up
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
build_action = node[:magento][:build][:action]
use_secure_frontend = node[:magento][:settings][:use_secure_frontend]
use_secure_admin = node[:magento][:settings][:use_secure_admin]
demo_structure = node[:magento][:init][:demo_structure]
warm_cache = node[:magento][:build][:hooks][:warm_cache]
enable_media_gallery = node[:magento][:build][:hooks][:enable_media_gallery]
commands = node[:magento][:build][:hooks][:commands]
vm_cli_commands = commands.reject { |command| command.include?(':') }
magento_cli_commands = commands.select { |command| command.include?(':') }

DemoStructureHelper.get_vhost_data(demo_structure).each do |vhost|
  next if (vhost[:scope] == 'website' && vhost[:code] == 'base') ||
          (vhost[:scope] == 'store_view' && vhost[:code] == 'default')

  scope_value = vhost[:scope] == 'store' ? 'store view' : vhost[:scope]

  magento_cli "Configuring additional unsecure URL for the #{vhost[:code]} #{scope_value}" do
    action :config_set
    config_path 'web/unsecure/base_url'
    config_value "http://#{vhost[:url]}/"
    config_scope vhost[:scope]
    config_scope_code vhost[:code]
    not_if { use_secure_frontend == 1 || use_secure_admin == 1 }
    only_if { DatabaseHelper.check_code_exists(vhost[:code]) }
  end
  magento_cli "Configuring additional secure URL for the #{vhost[:code]} #{scope_value}" do
    action :config_set
    config_path 'web/secure/base_url'
    config_value "https://#{vhost[:url]}/"
    config_scope vhost[:scope]
    config_scope_code vhost[:code]
    only_if do
      use_secure_frontend == 1 || use_secure_admin == 1 &&
        DatabaseHelper.check_code_exists(vhost[:code])
    end
  end
end

mysql 'Configure default store' do
  action :run_query
  db_query "UPDATE store_website SET default_group_id = '1' WHERE code = 'base'"
end

media_gallery_commands = "config:set system/media_gallery/enabled #{ValueHelper.process_value(enable_media_gallery)}"
media_gallery_commands = [media_gallery_commands, 'media-gallery:sync'] if enable_media_gallery

magento_cli 'Running the enable_media_gallery hook' do
  action :run
  command_list media_gallery_commands
  not_if do
    enable_media_gallery.nil? || enable_media_gallery.empty? ||
      ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install'
  end
end

magento_cli 'Running user Magento CLI hooks' do
  action :run
  command_list magento_cli_commands
  not_if do
    commands.nil? || commands.empty? ||
      ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install'
  end
end

vm_cli 'Running user VM CLI hooks' do
  action :run
  command_list vm_cli_commands
  not_if do
    commands.nil? || commands.empty? ||
      ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install'
  end
end

vm_cli 'Running the warm cache hook' do
  action :run
  command_list 'warm-cache'
  only_if { warm_cache }
  not_if do
    warm_cache.nil? || warm_cache.empty? ||
      ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install'
  end
end
