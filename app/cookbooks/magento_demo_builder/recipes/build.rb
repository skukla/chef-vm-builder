#
# Cookbook:: magento_demo_builder
# Recipe:: build
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento_demo_builder][:init][:web_root]
data_pack_list = node[:magento_demo_builder][:data_pack_list]

unless ::Dir.empty?(web_root)
  unless data_pack_list.empty?
    data_pack_list.each do |data_pack_key, data_pack_value|
      magento_demo_builder "Building the #{data_pack_value['package_name']} data pack" do
        action :build_local_data_pack
        data_pack_data({ key: data_pack_key, value: data_pack_value })
      end

      magento_demo_builder "Installing data files into the #{data_pack_value['package_name']} data pack" do
        action :install_local_data_pack_content
        data_pack_data({ key: data_pack_key, value: data_pack_value })
      end

      magento_demo_builder 'Cleaning up data pack' do
        action :clean_up_data_pack
        data_pack_data({ key: data_pack_key, value: data_pack_value })
      end
    end
  end

  magento_app 'Set permissions on directories and files' do
    action :set_permissions
    permission_dirs ['var/', 'pub/']
  end
end
