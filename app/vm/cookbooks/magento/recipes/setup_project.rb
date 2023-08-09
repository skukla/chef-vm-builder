# Cookbook:: magento
# Recipe:: setup_project
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]
composer_json = "#{web_root}/composer.json"
allowed_composer_plugins_list = node[:magento][:composer][:allowed_plugins_list]
restore_mode = node[:magento][:magento_restore][:mode]
merge_restore = (build_action == 'restore' && restore_mode == 'merge')

if %w[install force_install update_all update_app].include?(build_action)
  composer 'Set the project stability and update sort-packages setting' do
    action :set_project_stability
    only_if { ::File.exist?(composer_json) }
  end
end

if %w[install force_install update_all update_app].include?(build_action) ||
     merge_restore
  magento_app 'Remove outdated repositories' do
    action :remove_repositories
    only_if do
      ::File.exist?(composer_json) &&
        ::File.foreach(composer_json).grep(/replace/).none?
    end
  end

  magento_app 'Remove outdated modules' do
    action :remove_modules
    only_if do
      ::File.exist?(composer_json) &&
        ::File.foreach(composer_json).grep(/replace/).none?
    end
  end
end

if %w[update_all update_app].include?(build_action) || merge_restore
  unless allowed_composer_plugins_list.empty?
    allowed_composer_plugins_list.each do |plugin|
      composer "Setting composer plugin: #{plugin.source} to #{plugin.status}" do
        action :config
        setting "allow-plugins.#{plugin.source} #{plugin.status}"
        options %w[no-plugins]
        only_if { ::Dir.exist?(web_root) }
      end
    end
  end
end
