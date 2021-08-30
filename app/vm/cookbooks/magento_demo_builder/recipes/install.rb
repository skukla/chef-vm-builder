# Cookbook:: magento_demo_builder
# Recipe:: install
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = DataPackHelper.local_list

unless data_pack_list.nil?
	data_pack_list.each do |data_pack|
		magento_demo_builder 'Install data pack via the CLI' do
			action :install
			data_pack_data DataPackHelper.prepare_names(data_pack)
		end
	end
end
