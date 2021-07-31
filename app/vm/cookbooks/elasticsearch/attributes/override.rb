# Cookbook:: elasticsearch
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings use, version, host, port, memory, plugins
#
# frozen_string_literal: true

setting = ConfigHelper.value('infrastructure/elasticsearch')

unless setting.nil?
	override[:elasticsearch][:version] = setting if setting.is_a?(String)
	if setting.is_a?(Hash)
		setting.each do |key, value|
			value = value.downcase if key == 'memory'
			override[:elasticsearch][key] = value
		end
	end
end
