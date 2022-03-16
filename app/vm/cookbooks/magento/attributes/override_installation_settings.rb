# Cookbook:: magento
# Attribute:: override_installation_settings
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: backend_frontname language currency admin_firstname admin_lastname
# admin_email admin_user admin_password use_secure_frontend use_secure_admin encryption_key
# frozen_string_literal: true

setting = ConfigHelper.value('application/settings')
base_url = DemoStructureHelper.base_url

unless setting.nil?
	setting.each do |key, value|
		override[:magento][:settings][key] = ValueHelper.bool_to_int(value)
	end
end
unless base_url.empty?
	override[:magento][:settings][:admin_email] = "admin@#{base_url}"
	override[:magento][:settings][:unsecure_base_url] = "http://#{base_url}/"
	override[:magento][:settings][:secure_base_url] = "https://#{base_url}/"
end
