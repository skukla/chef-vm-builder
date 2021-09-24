# Cookbook:: elasticsearch
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

setting = ConfigHelper.value('infrastructure/elasticsearch')

unless setting.nil?
	override[:elasticsearch][:version] = setting if setting.is_a?(String)
	if setting.is_a?(Hash)
		setting.each { |key, value| override[:elasticsearch][key] = value }
	end
end
