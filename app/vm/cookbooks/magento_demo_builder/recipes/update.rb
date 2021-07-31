# Cookbook:: magento_demo_builder
# Recipe:: update
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = DataPackHelper.remote_list

unless data_pack_list.empty?
	composer 'Update remote data pack code' do
		action :update
		package_name ComposerHelper.build_require_string(data_pack_list)
	end
end
