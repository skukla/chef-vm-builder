# Cookbook:: ssl
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: locality, region, country
# frozen_string_literal: true

setting = ConfigHelper.value('infrastructure/ssl')

if setting.is_a?(Hash) && !setting.empty?
	setting.each { |key, value| override[:ssl][key] = setting[key] }
end
