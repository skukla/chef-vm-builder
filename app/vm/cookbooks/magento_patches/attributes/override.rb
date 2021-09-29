# Cookbook:: magento_patches
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: apply, source, repository_directory, branch, codebase_directory
# frozen_string_literal: true

setting = ConfigHelper.value('application/build/patches')

override[:magento_patches][:apply] = setting if setting.is_a?(TrueClass) ||
	setting.is_a?(FalseClass)
if setting.is_a?(Hash) && !setting.empty?
	setting.each do |key, value|
		next if value.nil? || (value.is_a?(String) && value.empty?)

		override[:magento_patches][key] = setting[key]
	end
end
