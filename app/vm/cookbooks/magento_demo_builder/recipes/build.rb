# Cookbook:: magento_demo_builder
# Recipe:: build
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = node[:magento_demo_builder][:local_data_pack_list]
build_action = node[:magento_demo_builder][:magento][:build][:action]
restore_mode = node[:magento_demo_builder][:magento_restore][:mode]
merge_restore = (build_action == 'restore' && restore_mode == 'merge')

if !data_pack_list.empty? &&
     (
       %w[install force_install update_all update_data].include?(
         build_action,
       ) || merge_restore
     )
  data_pack_list.each do |data_pack|
    %w[data media].each do |media_type|
      magento_demo_builder "Clearing #{media_type} for the #{data_pack.module_string} data pack" do
        action :clear_data_and_media
        data_pack data_pack
        media_type media_type
      end
    end

    magento_demo_builder "Building the #{data_pack.module_string} data pack" do
      action %i[create_folders create_module_files]
      data_pack data_pack
    end

    %w[data media].each do |media_type|
      magento_demo_builder "Adding #{media_type} files to the #{data_pack.module_string} data pack" do
        action :add_media_and_data
        data_pack data_pack
        media_type media_type
      end
    end
  end

  if %w[update_data].include?(build_action)
    magento_cli 'Compiling dependencies after data pack creation' do
      action :di_compile
    end
  end

  if %w[install force_install update_all update_data].include?(build_action) ||
       merge_restore
    magento_app 'Set permissions on directories and files' do
      action :set_permissions
      permission_dirs %w[var/ pub/]
      remove_generated false
    end
  end
end
