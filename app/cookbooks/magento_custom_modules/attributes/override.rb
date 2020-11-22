#
# Cookbook:: magento_custom_modules
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_modules = node[:magento_custom_modules][:module_list]
supported_settings = %i[name version repository_url]
configured_custom_modules = node[:custom_demo][:custom_modules]
configured_data_packs = node[:custom_demo][:data_packs]

override[:magento_custom_modules][:module_list] = ModuleListHelper.get_module_data(
  supported_modules,
  supported_settings,
  configured_custom_modules
)
override[:magento_custom_modules][:data_pack_list] = ModuleListHelper.get_module_data(
  supported_modules,
  supported_settings,
  configured_data_packs
)
