# Cookbook:: magento
# Recipe:: add_modules
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]
separate_restore = node[:magento][:restore][:mode] == 'separate'
composer_json = "#{web_root}/composer.json"
data_pack_list = node[:magento][:data_packs][:data_pack_list]
custom_module_list = node[:magento][:custom_modules][:module_list]

if !custom_module_list.empty? &&
		%w[install force_install update_all update_app restore].include?(
			build_action,
		)
	custom_module_data 'Add custom modules to composer.json' do
		action :process
		data_type 'custom module'
		module_list custom_module_list
		only_if { ::File.exist?(composer_json) }
		not_if { separate_restore }
	end
end

if !data_pack_list.empty? &&
		%w[install force_install update_all update_data restore].include?(
			build_action,
		)
	custom_module_data 'Add data packs to composer.json' do
		action :process
		data_type 'data pack'
		module_list data_pack_list
		only_if { ::File.exist?(composer_json) }
		not_if { separate_restore }
	end
end
