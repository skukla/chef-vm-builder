# Cookbook:: magento
# Recipe:: download
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]
separate_restore = node[:magento][:restore][:mode] == 'separate'
apply_patches = node[:magento][:patches][:apply]
install_sample_data = node[:magento][:build][:sample_data]
sample_data_flag = "#{web_root}/var/.sample-data-state.flag"

if apply_patches &&
		%w[install force_install update_all update_app restore].include?(
			build_action,
		)
	ruby_block 'Include patches' do
		block { run_context.include_recipe 'magento_patches::default' }
		not_if { separate_restore }
	end
end

if %w[install force_install restore].include?(build_action)
	composer 'Downloading the codebase' do
		action :install
		only_if { separate_restore }
	end
end

if %w[update_all update_app restore].include?(build_action)
	composer 'Updating the codebase' do
		action :update
		not_if { separate_restore }
	end
end

if install_sample_data &&
		%w[install force_install update_all update_app].include?(build_action)
	magento_app 'Add sample data' do
		action :add_sample_data
		not_if { ::File.exist?(sample_data_flag) }
	end
end

if apply_patches &&
		%w[install force_install update_all update_app restore].include?(
			build_action,
		)
	ruby_block 'Apply patches' do
		block { run_context.include_recipe 'magento_patches::apply' }
		not_if { separate_restore }
	end
end

if %w[install force_install update_all update_app].include?(build_action)
	samba 'Create samba drop directories' do
		action :create_magento_shares
	end

	magento_app 'Set permissions after downloading code' do
		action :set_permissions
	end
end
