#
# Cookbook:: magento
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:init][:web_root]
build_action = node[:magento][:build][:action]
sample_data = node[:magento][:build][:sample_data]
apply_patches = node[:magento][:patches][:apply]

if (apply_patches && %w[force_install update].include?(build_action)) ||
   (apply_patches && build_action == 'install' && !::File.exist?("#{web_root}/var/.first-run-state.flag"))
  include_recipe 'magento_patches::default'
end

magento_app 'Download the codebase' do
  action :download
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action != 'force_install' }
  only_if do
    !::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' ||
      build_action == 'force_install'
  end
end

magento_app 'Update the codebase' do
  action :update
  only_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'update' }
end

magento_app 'Add sample data' do
  action :add_sample_data
  not_if do
    ::File.exist?("#{web_root}/var/.sample-data-state.flag") ||
      !sample_data
  end
end

if (apply_patches && %w[force_install update].include?(build_action)) ||
   (apply_patches && build_action == 'install' && !::File.exist?("#{web_root}/var/.first-run-state.flag"))
  include_recipe 'magento_patches::apply'
end

samba 'Create samba drop directories' do
  action :create_magento_shares
end

magento_app 'Set permissions after downloading code' do
  action :set_permissions
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end
