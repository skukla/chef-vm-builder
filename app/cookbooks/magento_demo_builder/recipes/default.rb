#
# Cookbook:: magento_demo_builder
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
build_action = node[:magento_demo_builder][:magento][:build][:action]
web_root = node[:magento_demo_builder][:init][:web_root]
data_packs_list = node[:magento_demo_builder][:data_packs]

unless data_packs_list.empty?
  data_packs_list.each do |data_pack_key, data_pack_value|
    magento_demo_builder "Remove existing data for the #{data_pack_value['name']} data pack from the database" do
      action :remove_data_patches
      data_pack_data({
                       key: data_pack_key,
                       value: data_pack_value
                     })
      only_if { build_action == 'update' }
    end

    magento_demo_builder "Build the #{data_pack_value['name']} data pack" do
      action :build_local_data_packs
      data_pack_data({
                       key: data_pack_key,
                       value: data_pack_value
                     })
    end

    magento_demo_builder "Install data files into the #{data_pack_value['name']} data pack" do
      action :install_local_data_pack_content
      data_pack_data({
                       key: data_pack_key,
                       value: data_pack_value
                     })
    end

    magento_demo_builder 'Clean up data packs' do
      action :clean_up_data_packs
      data_pack_data({
                       key: data_pack_key,
                       value: data_pack_value
                     })
    end
  end
end

magento_app 'Set permissions on directories and files' do
  action :set_permissions
  permission_dirs ['var/', 'pub/']
  not_if { ::File.exist?("#{web_root}/var/.first-run-state.flag") && build_action == 'install' }
end
