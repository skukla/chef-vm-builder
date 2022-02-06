# Cookbook:: magento_custom_modules
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

override[:magento_custom_modules][:module_list] = CustomModuleHelper.list

if node[:magento_custom_modules][:search_engine][:type] == 'live_search'
	override[:magento_custom_modules][:module_list] =
		CustomModuleHelper.list_with_live_search
end
