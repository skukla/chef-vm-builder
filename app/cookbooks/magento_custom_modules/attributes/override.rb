#
# Cookbook:: magento_custom_modules
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

supported_settings = %i[name version repository_url]
configured_custom_modules = node[:custom_demo][:custom_modules]

override[:magento_custom_modules][:module_list] = ModuleListHelper.get_module_data(
  supported_settings,
  configured_custom_modules,
  'custom_modules'
)
