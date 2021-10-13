# Cookbook:: magento_demo_builder
# Recipe:: install
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = node[:magento_demo_builder][:data_pack_list]
build_action = node[:magento_demo_builder][:magento][:build][:action]

if %w[install force_install update_all update_data].include?(build_action) &&
		!data_pack_list.empty?
	data_pack_list.each do |data_pack|
		magento_demo_builder 'Install data pack via the CLI' do
			action :install
			data_pack_data data_pack
		end
	end
end
