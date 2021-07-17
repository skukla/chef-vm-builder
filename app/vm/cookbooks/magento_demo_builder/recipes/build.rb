# Cookbook:: magento_demo_builder
# Recipe:: build
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = node[:magento_demo_builder][:data_pack_list]

unless data_pack_list.empty?
  data_pack_list.each do |data_pack_data|
    magento_demo_builder "Building, installing, and cleaning up the #{data_pack_data['name']} data pack" do
      action %i[clear_fixtures create_folders create_module_files]
      data_pack_data data_pack_data
      only_if { DataPackHelper.data_pack_exists?(data_pack_data['repository_url']) }
    end

    %w[data media].each do |media_type|
      magento_demo_builder "Adding #{media_type} files to the #{data_pack_data['name']} data pack" do
        action :add_media_and_data
        data_pack_data data_pack_data
        media_type media_type
        only_if { DataPackHelper.data_pack_exists?(data_pack_data['repository_url']) }
      end
    end

    magento_demo_builder "Cleaning up the #{data_pack_data['name']} data pack" do
      action :clean_up
      data_pack_data data_pack_data
      only_if { DataPackHelper.data_pack_exists?(data_pack_data['repository_url']) }
    end
  end
end

magento_app 'Set permissions on directories and files' do
  action :set_permissions
  permission_dirs ['var/', 'pub/']
  remove_generated false
end
