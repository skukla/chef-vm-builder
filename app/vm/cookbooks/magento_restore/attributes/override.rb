# Cookbook:: magento_restore
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: mode, source
# frozen_string_literal: true

setting = ConfigHelper.value('application/build/restore')

unless setting.nil?
	if setting.is_a?(Hash) && !setting.empty?
		setting.each do |key, value|
			next if value.nil? || (value.is_a?(String) && value.empty?)
			override[:magento_restore][key] = setting[key]
		end
	end
	override[:magento_restore][:mode] = setting if setting.is_a?(String) &&
		!setting.to_s.empty?
end
