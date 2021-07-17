# Cookbook:: elasticsearch
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings use, version, host, port, memory, plugins
#
# frozen_string_literal: true

setting = node[:infrastructure][:elasticsearch]

if setting.is_a?(Hash) && !setting.empty?
  override[:elasticsearch][:version] = setting if setting.is_a?(String)
  override[:elasticsearch][:use] = setting if setting.is_a?(TrueClass) || setting.is_a?(FalseClass)
  if setting.is_a?(Hash)
    setting.each do |key, value|
      next if value.nil? || (value.is_a?(String) && value.empty?)

      override[:elasticsearch][key] = if key == 'memory'
                                        setting[key].downcase
                                      else
                                        setting[key]
                                      end
    end
  end
end
