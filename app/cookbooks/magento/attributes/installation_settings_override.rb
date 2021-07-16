# Cookbook:: magento
# Attribute:: installation_settings_override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: backend_frontname language currency admin_firstname admin_lastname
# admin_email admin_user admin_password unsecure_base_url secure_base_url use_rewrites
# use_secure_frontend use_secure_admin cleanup_database session_save encryption_key
#
# frozen_string_literal: true

setting = node[:application][:settings]
base_entry = DemoStructureHelper.get_base_entry

if setting.is_a?(Hash) && !setting.empty?
	setting.each do |key, value|
		next if value.nil? || (value.is_a?(String) && value.empty?)

		override[:magento][:settings][key] = setting[key]
	end
end
unless base_entry.empty?
	override[:magento][:settings][:admin_email] = "admin@#{base_entry[:url]}"
	override[:magento][:settings][:unsecure_base_url] =
		"http://#{base_entry[:url]}/"
	override[:magento][:settings][:secure_base_url] =
		"https://#{base_entry[:url]}/"
end
