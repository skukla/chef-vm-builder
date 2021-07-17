# Cookbook:: magento_demo_builder
# Recipe:: install
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_pack_list = node[:magento_demo_builder][:data_pack_list]

unless data_pack_list.empty?
  data_pack_list.each do |data_pack_data|
    magento_demo_builder 'Install data pack via the CLI' do
      action :install
      data_pack_data data_pack_data
      only_if { DataPackHelper.data_pack_exists?(data_pack_data['repository_url']) }
    end
  end
end
