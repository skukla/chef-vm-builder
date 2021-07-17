#
# Cookbook:: magento
# Recipe:: set_urls
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_secure_frontend = node[:magento][:settings][:use_secure_frontend]
use_secure_admin = node[:magento][:settings][:use_secure_admin]
additional_entries = DemoStructureHelper.additional_entries

unless additional_entries.empty?
	additional_entries.each do |vhost|
		scope_value = vhost[:scope] == 'store' ? 'store view' : vhost[:scope]

		if use_secure_frontend.zero? || use_secure_admin.zero?
			magento_cli "Configuring additional unsecure URL for the #{vhost[:code]} #{scope_value}" do
				action :config_set
				config_path 'web/unsecure/base_url'
				config_value "http://#{vhost[:url]}/"
				config_scope vhost[:scope]
				config_scope_code vhost[:code]
				only_if { DatabaseHelper.check_code_exists(vhost[:code]) }
			end
		else
			magento_cli "Configuring additional secure URL for the #{vhost[:code]} #{scope_value}" do
				action :config_set
				config_path 'web/secure/base_url'
				config_value "https://#{vhost[:url]}/"
				config_scope vhost[:scope]
				config_scope_code vhost[:code]
				only_if { DatabaseHelper.check_code_exists(vhost[:code]) }
			end
		end
	end
end

mysql 'Configure default store' do
	action :run_query
	db_query "UPDATE store_website SET default_group_id = '1' WHERE code = 'base'"
end