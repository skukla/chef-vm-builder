# Cookbook:: mailhog
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: use, port, smtp_port
#
# frozen_string_literal: true

setting = node[:infrastructure][:mailhog]

override[:mailhog][:use] = setting if setting.is_a?(TrueClass) || setting.is_a?(FalseClass)
if setting.is_a?(Hash) && !setting.empty?
  setting.each do |key, value|
    next if value.nil? || (value.is_a?(String) && value.empty?)

    override[:mailhog][key] = setting[key]
  end
end
