# Cookbook:: nginx
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: web_root, http_port, client_max_body_size
#
# frozen_string_literal: true

setting = node[:infrastructure][:webserver]

if setting.is_a?(Hash) && !setting.empty?
  setting.each do |key, value|
    next if value.nil? || (value.is_a?(String) && value.empty?)

    override[:nginx][key] = setting[key]
  end
end
