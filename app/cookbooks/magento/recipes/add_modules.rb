#
# Cookbook:: magento
# Recipe:: add_modules
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
custom_module_list = node[:magento][:custom_modules]
data_pack_list = node[:magento][:data_packs]
web_root = node[:magento][:init][:web_root]

composer_json_found = ::File.exist?("#{web_root}/composer.json")
if composer_json_found
  custom_module_data 'Install data packs' do
    action :process
    data_type 'data_packs'
    data data_pack_list
  end

  custom_module_data 'Install custom modules' do
    action :process
    data_type 'custom_modules'
    data custom_module_list
  end
end
