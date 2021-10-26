# Cookbook:: nginx
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# Supported settings: web_root, client_max_body_size
# frozen_string_literal: true

setting = ConfigHelper.value('infrastructure/web_server')
if setting.is_a?(Hash)
	setting.each { |key, value| override[:nginx][key] = value }
end
