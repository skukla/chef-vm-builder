# Cookbook:: search_engine
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: host, memory
#
# frozen_string_literal: true

setting = ConfigHelper.value('infrastructure/search_engine')

override[:search_engine][:type] = setting if setting.is_a?(String)
if setting.is_a?(Hash)
	setting.each do |key, value|
		next if key == 'type'
		override[:search_engine][:elasticsearch][key] = setting[key].downcase
	end
end
