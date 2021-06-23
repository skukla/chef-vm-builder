#
# Cookbook:: magento
# Recipe:: add_modules
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
custom_module_list = node[:magento][:custom_modules]
data_pack_list = node[:magento][:data_packs]
web_root = node[:magento][:nginx][:web_root]
composer_json = "#{web_root}/composer.json"

custom_module_data 'Install data packs' do
  action :process
  data_type 'data_packs'
  data data_pack_list
  only_if { ::File.exist?(composer_json) }
end

custom_module_data 'Install custom modules' do
  action :process
  data_type 'custom_modules'
  data custom_module_list
  only_if { ::File.exist?(composer_json) }
end
