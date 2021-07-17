# Cookbook:: magento_demo_builder
# Recipe:: update
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = node[:magento_demo_builder][:data_pack_list]
remote_data_pack_list = data_pack_list.select do |module_data|
  module_data.key?(:repository_url) && module_data[:repository_url].include?('github')
end

unless remote_data_pack_list.empty?
  composer 'Update remote data pack code' do
    action :update
    package_name ModuleListHelper.build_require_string(remote_data_pack_list)
  end
end
