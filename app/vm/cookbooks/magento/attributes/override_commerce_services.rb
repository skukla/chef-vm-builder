# Cookbook:: magento
# Attribute:: override_commerce_services
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: production_api_key, project_id, environment_id (data_space_id)
# frozen_string_literal: true

setting = ConfigHelper.value('application/authentication/commerce_services')

unless setting.nil?
  setting.each do |key, value|
    key = key.sub('data_space', 'environment') if key.include?('data_space')
    override[:magento][:csc_options][key][:value] = value
  end
end

override[:magento][:csc_options][:sandbox_private_key][:value] =
  ServicesHelper.read_private_key('privateKey-sandbox.pem')
override[:magento][:csc_options][:production_private_key][:value] =
  ServicesHelper.read_private_key('privateKey-production.pem')
