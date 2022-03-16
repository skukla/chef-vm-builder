# Cookbook:: magento
# Attribute:: override_application_options
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: family, minimum_stability, version
# frozen_string_literal: true

setting = ConfigHelper.value('application/options')

unless setting.nil?
	setting.each do |key, value|
		value = MagentoHelper.define_family(value) if key == 'family'
		override[:magento][:options][key] = value
	end
end
