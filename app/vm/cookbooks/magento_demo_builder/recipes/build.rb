# Cookbook:: magento_demo_builder
# Recipe:: build
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = DataPackHelper.local_list

unless data_pack_list.nil?
	data_pack_list.each do |data_pack|
		data_pack = DataPackHelper.prepare_names(data_pack)

		magento_demo_builder "Building, installing, and cleaning up the #{data_pack['module_name']} data pack" do
			action %i[clear_fixtures create_folders create_module_files]
			data_pack_data data_pack
		end

		%w[data media].each do |media_type|
			magento_demo_builder "Adding #{media_type} files to the #{data_pack['module_name']} data pack" do
				action :add_media_and_data
				data_pack_data data_pack
				media_type media_type
			end
		end

		if data_pack['source'].include?('github')
			magento_demo_builder "Cleaning up the #{data_pack['module_name']} data pack" do
				action :clean_up
				data_pack_data data_pack
			end
		end
	end
end

magento_app 'Set permissions on directories and files' do
	action :set_permissions
	permission_dirs %w[var/ pub/]
	remove_generated false
end
