# Cookbook:: magento_modules
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

add_required_modules =
  node[:magento_modules][:magento][:build][:add_required_modules]

required_modules = node[:magento_modules][:required_module_list]
sample_data_modules = node[:magento_modules][:sample_data_module_list]
custom_modules = ConfigHelper.value('custom_demo/custom_modules')
repositories_to_remove =
  ConfigHelper.value('application/build/repositories_to_remove')
default_to_remove = node[:magento_modules][:modules_to_remove]
user_to_remove = ConfigHelper.value('application/build/modules_to_remove')

required_module_list = ListHelper::AppModuleList.new(required_modules)
sample_data_module_list = ListHelper::AppModuleList.new(sample_data_modules)
remove_repositories_list = ListHelper::AppModuleList.new(repositories_to_remove)
custom_module_list = ListHelper::AppModuleList.new(custom_modules)
default_to_remove_list = ListHelper::AppModuleList.new(default_to_remove)
user_to_remove_list = ListHelper::AppModuleList.new(user_to_remove)

module_list = custom_module_list.github_modules unless add_required_modules
module_list =
  required_module_list.github_modules +
    custom_module_list.github_modules if add_required_modules

override[:magento_modules][:github_module_list] = module_list

module_list = custom_module_list.non_github_modules unless add_required_modules
module_list =
  required_module_list.non_github_modules +
    custom_module_list.non_github_modules if add_required_modules

override[:magento_modules][:packagist_module_list] = module_list

override[:magento_modules][:sample_data_module_list] =
  sample_data_module_list.non_github_modules

override[:magento_modules][:repositories_to_remove_list] =
  remove_repositories_list.all_modules

override[:magento_modules][:modules_to_remove_list] =
  default_to_remove_list.all_modules + user_to_remove_list.all_modules
