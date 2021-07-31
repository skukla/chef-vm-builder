# Cookbook:: nginx
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings: web_root, http_port, client_max_body_size
#
# frozen_string_literal: true

setting = ConfigHelper.value('infrastructure/webserver')

setting.each { |key, value| override[:nginx][key] = value } unless setting.nil?
