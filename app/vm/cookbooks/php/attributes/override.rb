# Cookbook:: php
# Attribute:: override
# Supported settings: version, fpm_port, memory_limit, upload_max_filesize
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

setting = ConfigHelper.value('infrastructure/php')

override[:php][:version] = setting if setting.is_a?(String)
if setting.is_a?(Hash) && !setting.empty?
	setting.each do |key, value|
		next if value.nil? || (value.is_a?(String) && value.empty?)

		override[:php][key] = setting[key]
	end
end
