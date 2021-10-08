# Cookbook:: magento_demo_builder
# Recipe:: update
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = node[:magento_demo_builder][:remote_data_pack_list]

unless data_pack_list.empty?
	require_str = ComposerHelper.build_require_string(data_pack_list)

	composer "Updating #{require_str} code" do
		action :update
		package_name
	end
end
