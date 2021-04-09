#
# Cookbook:: magento_demo_builder
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
data_pack_list = node[:magento_demo_builder][:data_pack_list]

unless data_pack_list.empty?
  data_pack_list.each do |data_pack_key, data_pack_value|
    magento_demo_builder 'Install data pack via the CLI' do
      action :install_data_pack
      data_pack_data({ key: data_pack_key, value: data_pack_value })
    end
  end
end
