# Cookbook:: magento
# Attribute:: override_build_options
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: action, sample_data, modules_to_remove, deploy_mode {apply, mode}
# frozen_string_literal: true

setting = ConfigHelper.value('application/build')

unless setting.nil?
	setting.each do |key, value|
		case key
		when 'sample_data'
			override[:magento][:build][:sample_data][:apply] = value
		when 'action', 'modules_to_remove'
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
