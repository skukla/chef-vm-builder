# Cookbook:: magento_demo_builder
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

setting = node[:custom_demo][:data_packs]
data_pack_list = []

if setting.is_a?(Hash) && !setting.empty?
  setting.each do |_data_pack_key, data_pack_data|
    data_pack_hash = {}
    next if data_pack_data.empty? || !data_pack_data.is_a?(Hash)

    data_pack_data.each do |key, value|
      next if value.nil? || (value.is_a?(String) && value.empty?)

      data_pack_hash[key.to_sym] = value
      if key == 'name' && value.include?('/')
        data_pack_hash[:vendor] = value.split('/')[0]
        data_pack_hash[:module_name] = value.split('/')[1]
      end
    end
    data_pack_list << data_pack_hash
  end
  override[:magento_demo_builder][:data_pack_list] = data_pack_list
end
