# Cookbook:: magento_restore
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: mode, source
# frozen_string_literal: true

setting = ConfigHelper.value('application/build/restore')

override[:magento_restore][:mode] = setting if setting.is_a?(String)
if setting.is_a?(Hash)
	setting.each { |key, value| override[:magento_restore][key] = setting[key] }
end
