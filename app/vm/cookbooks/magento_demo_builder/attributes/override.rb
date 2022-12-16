# Cookbook:: magento_demo_builder
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

data_packs = ConfigHelper.value('custom_demo/data_packs')
list = ListHelper::DataPackList.new(data_packs).all_modules
override[:magento_demo_builder][:data_pack_list] = list

list = ListHelper::DataPackList.new(data_packs).github_modules
override[:magento_demo_builder][:github_data_pack_list] = list

list = ListHelper::DataPackList.new(data_packs).non_github_modules
override[:magento_demo_builder][:local_data_pack_list] = list
