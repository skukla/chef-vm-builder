# Cookbook:: magento_modules
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

required_modules = node[:magento_modules][:required_module_list]
sample_data_modules = node[:magento_modules][:sample_data_module_list]
custom_modules = ConfigHelper.value('custom_demo/custom_modules')
default_to_remove = node[:magento_modules][:modules_to_remove]
user_to_remove = ConfigHelper.value('application/build/modules_to_remove')

required_module_list = ListHelper::AppModuleList.new(required_modules)
sample_data_module_list = ListHelper::AppModuleList.new(sample_data_modules)
custom_module_list = ListHelper::AppModuleList.new(custom_modules)
default_to_remove_list = ListHelper::AppModuleList.new(default_to_remove)
user_to_remove_list = ListHelper::AppModuleList.new(user_to_remove)

override[:magento_modules][:github_module_list] =
  required_module_list.github_modules + custom_module_list.github_modules

override[:magento_modules][:packagist_module_list] =
  required_module_list.non_github_modules +
    custom_module_list.non_github_modules

override[:magento_modules][:sample_data_module_list] =
  sample_data_module_list.non_github_modules

override[:magento_modules][:modules_to_remove] =
  default_to_remove_list.all_modules + user_to_remove_list.all_modules
