# Cookbook:: mysql
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: version, db_host, db_port, db_user, db_password, db_name
# frozen_string_literal: true

setting = ConfigHelper.value('infrastructure/database')

override[:mysql][:db_name] = setting if setting.is_a?(String)
if setting.is_a?(Hash)
	setting.each { |key, value| override[:mysql][key] = value }
end
