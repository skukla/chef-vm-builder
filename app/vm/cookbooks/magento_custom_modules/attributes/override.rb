# Cookbook:: magento_custom_modules
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

setting = node[:custom_demo][:custom_modules]
module_list = []

if setting.is_a?(Hash) && !setting.empty?
  setting.each do |_module_key, module_data|
    module_hash = {}
    next if module_data.empty?

    if module_data.is_a?(String)
      module_hash[:name] = module_data
      module_hash[:vendor] = module_data.split('/')[0]
      module_hash[:module_name] = module_data.split('/')[1]
      module_list << module_hash
    end

    next unless module_data.is_a?(Hash)

    module_data.each do |key, value|
      next if value.nil? || (value.is_a?(String) && value.empty?)

      module_hash[key.to_sym] = value
      if key == 'name' && value.include?('/')
        module_hash[:vendor] = value.split('/')[0]
        module_hash[:module_name] = value.split('/')[1]
      end
    end
    module_hash[:version] = 'dev-master' if module_data[:version].nil?
    module_list << module_hash
  end
  override[:magento_custom_modules][:module_list] = module_list
end
