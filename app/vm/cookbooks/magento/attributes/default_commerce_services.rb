# Cookbook:: magento
# Attribute:: default_commerce_services
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:magento][:csc_options][:key_path] =
  '/var/chef/cache/cookbooks/magento/files/default'

default[:magento][:csc_options][:sandbox_api_key] = {
  config_path:
    'services_connector/services_connector_integration/sandbox_api_key',
  insert_method: 'cli',
  value: '',
}
default[:magento][:csc_options][:sandbox_private_key] = {
  config_path:
    'services_connector/services_connector_integration/sandbox_private_key',
  insert_method: 'query',
  value: '',
}
default[:magento][:csc_options][:production_api_key] = {
  config_path:
    'services_connector/services_connector_integration/production_api_key',
  insert_method: 'cli',
  value: '',
}
default[:magento][:csc_options][:production_private_key] = {
  config_path:
    'services_connector/services_connector_integration/production_private_key',
  insert_method: 'query',
  value: '',
}
default[:magento][:csc_options][:project_name] = {
  config_path: 'services_connector/services_id/project_name',
  insert_method: 'query',
  value: '',
}

default[:magento][:csc_options][:project_id] = {
  config_path: 'services_connector/services_id/project_id',
  insert_method: 'query',
  value: '',
}

default[:magento][:csc_options][:environment_id] = {
  config_path: 'services_connector/services_id/environment_id',
  insert_method: 'cli',
  value: '',
}

default[:magento][:csc_options][:environment_name] = {
  config_path: 'services_connector/services_id/environment_name',
  insert_method: 'query',
  value: '',
}

default[:magento][:csc_options][:environment_type] = {
  config_path: 'services_connector/services_id/environment',
  insert_method: 'query',
  value: '',
}
