# Cookbook:: magento
# Attribute:: override_build_hooks
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: warm_cache, enable_media_gallery, commands[]
# frozen_string_literal: true

setting = ConfigHelper.value('application/build/hooks')

unless setting.nil?
	setting.each { |key, value| override[:magento][:build][:hooks][key] = value }
end
