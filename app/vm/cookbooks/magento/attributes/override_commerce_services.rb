# Cookbook:: magento
# Attribute:: override_commerce_services
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: production_api_key, project_id, environment_id (data_space_id)
# frozen_string_literal: true

setting = ConfigHelper.value('application/authentication/commerce_services')

unless setting.nil?
	setting.each do |key, value|
		if key == 'data_space_id'
			override[:magento][:csc_options][:environment_id] = value
		end
		override[:magento][:csc_options][key] = value unless key == 'data_space_id'
	end
end
override[:magento][:csc_options][:production_private_key] =
	ServicesHelper.read_production_key
