# Cookbook:: magento
# Recipe:: add_modules
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
family = node[:magento][:options][:family]
build_action = node[:magento][:build][:action]
restore_mode = node[:magento][:magento_restore][:mode]
merge_restore = (build_action == 'restore' && restore_mode == 'merge')
composer_json = "#{web_root}/composer.json"
github_module_list = node[:magento][:magento_modules][:github_module_list]
packagist_module_list = node[:magento][:magento_modules][:packagist_module_list]
sample_data_module_list =
  node[:magento][:magento_modules][:sample_data_module_list]
github_data_pack_list = node[:magento][:data_packs][:github_data_pack_list]
install_sample_data = node[:magento][:build][:sample_data][:apply]
sample_data_flag = "#{web_root}/var/.sample-data-state.flag"

if !github_module_list.empty? &&
     (
       %w[install force_install update_all update_app].include?(build_action) ||
         merge_restore
     )
  module_data 'Adding module repositories to composer.json' do
    action :add_repositories
    module_list github_module_list
    only_if { ::File.exist?(composer_json) }
  end
end

module_list = packagist_module_list + github_module_list

if !module_list.empty?
  module_data 'Adding custom modules to composer.json' do
    action :add_modules
    module_list module_list
    only_if { ::File.exist?(composer_json) }
  end
end

if !github_data_pack_list.empty? &&
     (
       %w[install force_install update_all update_data].include?(
         build_action,
       ) || merge_restore
     )
  module_data 'Adding data pack repositories to composer.json' do
    action :add_repositories
    module_list github_data_pack_list
    only_if { ::File.exist?(composer_json) }
  end

  module_data 'Adding data packs to composer.json' do
    action :add_modules
    module_list github_data_pack_list
    only_if { ::File.exist?(composer_json) }
  end
end

if install_sample_data &&
     (
       %w[install force_install update_all update_app].include?(build_action) ||
         merge_restore
     )
  module_data 'Adding sample data modules to composer.json' do
    action :add_modules
    module_list sample_data_module_list
    only_if { ::File.exist?(composer_json) }
    not_if { ::File.exist?(sample_data_flag) }
  end
end
