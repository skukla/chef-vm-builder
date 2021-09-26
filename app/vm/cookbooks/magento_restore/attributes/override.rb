# Cookbook:: magento_restore
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: source, update_code
# frozen_string_literal: true

setting = ConfigHelper.value('application/build/restore')

unless setting.nil?
	override[:magento_restore][:update_code] = setting == TrueClass ? false : true
	if setting.is_a?(Hash) && !setting.empty?
		setting.each do |key, value|
			next if value.nil? || (value.is_a?(String) && value.empty?)

			override[:magento_restore][key] = setting[key]
		end
	end
end
