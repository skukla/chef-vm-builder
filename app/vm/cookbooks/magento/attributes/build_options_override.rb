# Cookbook:: magento
# Attribute:: build_options_override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: action, sample_data, modules_to_remove, consumer_list deploy_mode {apply, mode}
#
# frozen_string_literal: true

setting = ConfigHelper.value('application/build')

unless setting.nil?
	setting.each do |key, value|
		case key
		when 'action', 'sample_data'
			override[:magento][:build][key] = value
		when 'deploy_mode'
			if value.is_a?(String)
				override[:magento][:build][key][:apply] = true
				override[:magento][:build][key][:mode] = value
			end
			if value.is_a?(TrueClass) || value.is_a?(FalseClass)
				override[:magento][:build][key][:apply] = value
				override[:magento][:build][key][:mode] = 'production'
			end
			if value.is_a?(Hash)
				value.each { |k, v| override[:magento][:build][k] = v }
			end
		end
	end
end
