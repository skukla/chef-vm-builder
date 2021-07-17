# Cookbook:: mysql
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: db_host, db_port, db_user, db_password, db_name
#
# frozen_string_literal: true

setting = node[:infrastructure][:database]

override[:mysql][:db_name] = setting if setting.is_a?(String)
if setting.is_a?(Hash)
  setting.each do |key, value|
    next if value.nil? || (value.is_a?(String) && value.empty?)

    override[:mysql][key] = setting[key]
  end
end
