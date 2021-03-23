#
# Cookbook:: magento_demo_builder
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
supported_settings = %i[name version repository_url]
configured_data_packs = node[:custom_demo][:data_packs]

override[:magento_demo_builder][:data_pack_list] = ModuleListHelper.get_module_data(
  supported_settings,
  configured_data_packs,
  'data_packs'
)
