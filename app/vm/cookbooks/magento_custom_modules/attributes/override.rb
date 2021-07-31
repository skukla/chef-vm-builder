# Cookbook:: magento_custom_modules
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

setting = CustomModuleHelper.list

unless setting.nil?
	list =
		setting.each_with_object([]) do |m, arr|
			m['version'] = 'dev-master' if !m['source'].nil? && m['version'].nil?
			arr << m
		end
	override[:magento_custom_modules][:module_list] = list
end
