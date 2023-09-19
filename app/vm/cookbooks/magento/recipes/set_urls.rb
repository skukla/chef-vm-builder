# Cookbook:: magento
# Recipe:: set_urls
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

build_action = node[:magento][:build][:action]
use_secure_frontend = node[:magento][:settings][:use_secure_frontend]
use_secure_admin = node[:magento][:settings][:use_secure_admin]
unsecure_base_url = node[:magento][:settings][:unsecure_base_url]
secure_base_url = node[:magento][:settings][:secure_base_url]
additional_entries = DemoStructureHelper.additional_entries

if %w[restore update_urls].include?(build_action)
  magento_cli 'Configuring unsecure URL for the default scope' do
    action :config_set
    config_path 'web/unsecure/base_url'
    config_value "#{unsecure_base_url}"
    config_scope 'default'
    config_scope_code ''
  end

  magento_cli 'Configuring secure URL for the default scope' do
    action :config_set
    config_path 'web/secure/base_url'
    config_value "#{secure_base_url}"
    config_scope 'default'
    config_scope_code ''
  end
end

magento_cli 'Configuring unsecure URL for the base website' do
  action :config_set
  config_path 'web/unsecure/base_url'
  config_value "#{unsecure_base_url}"
  config_scope 'website'
  config_scope_code 'base'
end

magento_cli 'Configuring secure URL for the base website' do
  action :config_set
  config_path 'web/secure/base_url'
  config_value "#{secure_base_url}"
  config_scope 'website'
  config_scope_code 'base'
end

unless additional_entries.nil?
  additional_entries.each do |vhost|
    scope_value = vhost['scope'] == 'store' ? 'store view' : vhost['scope']
    magento_cli "Configuring additional unsecure URL for the #{vhost['code']} #{scope_value}" do
      action :config_set
      config_path 'web/unsecure/base_url'
      config_value "http://#{vhost['url']}/"
      config_scope vhost['scope']
      config_scope_code vhost['code']
      only_if { DatabaseHelper.code_exists?(vhost['code']) }
    end

    magento_cli "Configuring additional secure URL for the #{vhost['code']} #{scope_value}" do
      action :config_set
      config_path 'web/secure/base_url'
      config_value "https://#{vhost['url']}/"
      config_scope vhost['scope']
      config_scope_code vhost['code']
      only_if { DatabaseHelper.code_exists?(vhost['code']) }
    end
  end
end

mysql 'Configure default store' do
  action :run_query
  db_query "UPDATE store_website SET default_group_id = '1' WHERE code = 'base'"
end
