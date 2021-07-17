# Cookbook:: composer
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings:
# authentication: public_key, private_key, github_token
# infrastructure: version
#
# frozen_string_literal: true

settings_arr = [
  node[:application][:authentication][:composer],
  node[:infrastructure][:composer]
]

override[:composer][:version] = node[:infrastructure][:composer] if node[:infrastructure][:composer].is_a?(String)

settings_arr.each do |setting|
  next if !setting.is_a?(Hash) || setting.empty?

  setting.each do |key, value|
    next if value.nil? || (value.is_a?(String) && value.empty?)

    override[:composer][key] = setting[key]
  end
end
