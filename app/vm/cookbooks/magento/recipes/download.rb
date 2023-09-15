# Cookbook:: magento
# Recipe:: download
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]
restore_mode = node[:magento][:magento_restore][:mode]
merge_restore = (build_action == 'restore' && restore_mode == 'merge')
separate_restore = (build_action == 'restore' && restore_mode == 'separate')
apply_patches = node[:magento][:patches][:apply]
github_data_pack_list = node[:magento][:data_packs][:github_data_pack_list]
install_sample_data = node[:magento][:build][:sample_data][:apply]
sample_data_flag = "#{web_root}/var/.sample-data-state.flag"

if apply_patches &&
     (
       %w[install force_install update_all update_app].include?(build_action) ||
         merge_restore
     )
  include_recipe 'magento_patches::default'
end

if %w[install force_install].include?(build_action) || separate_restore
  composer 'Downloading the codebase' do
    action :install
  end
end

if %w[update_all update_app].include?(build_action) || merge_restore
  composer 'Updating the codebase' do
    action :update
  end
end

if install_sample_data &&
     (
       %w[install force_install update_all update_app].include?(build_action) ||
         merge_restore
     )
  magento_app 'Adding sample data media' do
    action :add_sample_data_media
    not_if { ::File.exist?(sample_data_flag) }
  end
end

if apply_patches &&
     (
       %w[install force_install update_all update_app].include?(build_action) ||
         merge_restore
     )
  include_recipe 'magento_patches::apply'
end

if %w[install force_install update_all update_app].include?(build_action)
  samba 'Create samba drop directories' do
    action :create_magento_shares
  end
end

if build_action != 'update_data' ||
     (build_action == 'update_data' && !github_data_pack_list.empty?)
  magento_app 'Set permissions after downloading code' do
    action :set_permissions
  end
end
