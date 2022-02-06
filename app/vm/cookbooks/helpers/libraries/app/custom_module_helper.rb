# Cookbook:: helpers
# Library:: app/custom_module_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

require_relative 'config_helper'

class CustomModuleHelper
	def CustomModuleHelper.list
		list = ConfigHelper.value('custom_demo/custom_modules')
		return [] if list.nil? || list.empty?

		list.map { |md| ModuleSharedHelper.prepare_data(md, :cm) }
	end

	def CustomModuleHelper.list_with_live_search
		live_search_module = {
			source: 'magento/live-search',
			vendor_string: 'magento',
			package_name: 'magento/magento/live-search',
			module_string: 'magento/live-search',
			vendor_name: 'magento',
			module_name: 'Magento/liveSearch',
		}

		list << live_search_module
	end
end
