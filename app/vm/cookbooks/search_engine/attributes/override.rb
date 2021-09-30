# Cookbook:: search_engine
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

setting = ConfigHelper.value('infrastructure/search_engine')

unless setting.nil?
	override[:search_engine][:type] = setting if setting.is_a?(String)
	if setting.is_a?(Hash)
		setting.each { |key, value| override[:search_engine][key] = value }
	end
end
