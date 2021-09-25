# Cookbook:: magento_demo_builder
# Recipe:: install
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = DataPackHelper.local_list
build_action = node[:magento_demo_builder][:magento][:build][:action]

unless data_pack_list.nil?
	if %w[refresh].include?(build_action)
		magento_cli 'Compiling dependencies after data pack creation' do
			action :di_compile
		end
	end

	data_pack_list.each do |data_pack|
		magento_demo_builder 'Install data pack via the CLI' do
			action :install
			data_pack_data DataPackHelper.prepare_names(data_pack)
		end
	end
end
