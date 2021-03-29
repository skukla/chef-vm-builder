#
# Cookbook:: magento_demo_builder
# Recipe:: update
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento_demo_builder][:init][:web_root]
data_pack_list = node[:magento_demo_builder][:data_pack_list]
remote_data_packs = ModuleListHelper.get_remote_data_packs(data_pack_list)

if !::Dir.empty?(web_root) && !remote_data_packs.empty?
  composer 'Update remote data pack code' do
    action :update
    package_name ModuleListHelper.build_require_string(remote_data_packs)
  end
end
