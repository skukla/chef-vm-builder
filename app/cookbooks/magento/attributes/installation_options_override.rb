# Cookbook:: magento
# Attribute:: installation_options_override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: family, minimum_stability, version
#
# frozen_string_literal: true

setting = node[:application][:options]

if setting.is_a?(Hash) && !setting.empty?
  setting.each do |key, value|
    next if value.nil? || (value.is_a?(String) && value.empty?)

    override[:magento][:options][key] = if key == 'family' && value.to_s.downcase == 'commerce'
                                          'enterprise'
                                        else
                                          setting[key]
                                        end
  end
end
