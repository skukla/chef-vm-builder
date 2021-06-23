# Cookbook:: magento
# Attribute:: commerce_services_override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: production_api_key, project_id, environment_id
#
# frozen_string_literal: true

setting = node[:application][:authentication][:commerce_services_connector]

if setting.is_a?(Hash) && !setting.empty?
  setting.each do |key, value|
    next if value.is_a?(String) && value.empty?

    if key == 'data_space_id'
      override[:magento][:csc_options][:environment_id] = setting[key]
    else
      override[:magento][:csc_options][key] = setting[key]
    end
  end
  key_file = "#{node[:magento][:csc_options][:key_path]}/privateKey-production.pem"
  key_value = ''
  if File.exist?(key_file)
    File.readlines(key_file).each do |line|
      key_value += line
    end
    override[:magento][:csc_options][:production_private_key] = key_value
  end
end
