#
# Cookbook:: magento
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]
apply_patches = node[:magento][:patches][:apply]
install_sample_data = node[:magento][:build][:sample_data]
sample_data_flag = "#{web_root}/var/.sample-data-state.flag"

include_recipe 'magento_patches::default' if apply_patches

if %w[install force_install].include?(build_action)
	composer 'Download the codebase' do
		action :install
	end
end

if build_action == 'update'
	composer 'Update the codebase' do
		action :update
	end
end

if install_sample_data
	magento_app 'Add sample data' do
		action :add_sample_data
		not_if { ::File.exist?(sample_data_flag) }
	end
end

if apply_patches && %w[install force_install update].include?(build_action)
	include_recipe 'magento_patches::apply'
end

samba 'Create samba drop directories' do
	action :create_magento_shares
end

magento_app 'Set permissions after downloading code' do
	action :set_permissions
end
