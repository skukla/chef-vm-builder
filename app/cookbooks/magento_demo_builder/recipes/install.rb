#
# Cookbook:: magento_demo_builder
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento_demo_builder][:init][:web_root]
data_pack_list = node[:magento_demo_builder][:data_pack_list]

if !::Dir.empty?(web_root) && !data_pack_list.empty?
  data_pack_list.each do |data_pack_key, data_pack_value|
    magento_demo_builder 'Install data pack via the CLI' do
      action :install_data_pack
      data_pack_data({ key: data_pack_key, value: data_pack_value })
    end
  end
end
