# Cookbook:: magento
# Attribute:: build_hooks_override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: warm_cache, enable_media_gallery, commands[]
#
# frozen_string_literal: true

setting = node[:application][:build][:hooks]

if setting.is_a?(Hash) && !setting.empty?
  setting.each do |key, value|
    next if value.nil? || (value.is_a?(String) && value.empty?)

    override[:magento][:build][:hooks][key] = setting[key]
  end
end
