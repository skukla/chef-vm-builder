#
# Cookbook:: magento
# Recipe:: set_urls
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
use_secure_frontend = node[:magento][:settings][:use_secure_frontend]
use_secure_admin = node[:magento][:settings][:use_secure_admin]
demo_structure = node[:magento][:init][:demo_structure]

DemoStructureHelper.get_vhost_data(demo_structure).each do |vhost|
  next if (vhost[:scope] == 'website' && vhost[:code] == 'base') ||
          (vhost[:scope] == 'store_view' && vhost[:code] == 'default')

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

mysql 'Configure default store' do
  action :run_query
  db_query "UPDATE store_website SET default_group_id = '1' WHERE code = 'base'"
end
