#
# Cookbook:: magento
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
build_action = node[:magento][:build][:action]
apply_patches = node[:magento][:patches][:apply]
install_sample_data = node[:magento][:build][:sample_data]
sample_data_flag = "#{web_root}/var/.sample-data-state.flag"
sample_data_installed = ::File.exist?(sample_data_flag)

include_recipe 'magento_patches::default' if apply_patches && %w[install force_install update].include?(build_action)

if %w[install force_install].include?(build_action)
  magento_app 'Download the codebase' do
    action :download
  end
end

if build_action == 'update'
  magento_app 'Update the codebase' do
    action :update
  end
end

if install_sample_data
  magento_app 'Add sample data' do
    action :add_sample_data
    not_if { sample_data_installed }
  end
end

include_recipe 'magento_patches::apply' if apply_patches && %w[install force_install update].include?(build_action)

samba 'Create samba drop directories' do
  action :create_magento_shares
end

magento_app 'Set permissions after downloading code' do
  action :set_permissions
end
