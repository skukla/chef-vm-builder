# Cookbook:: composer
# Attribute:: override
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
#
# Supported settings:
# authentication: public_key, private_key, github_token
# infrastructure: version, clear_cache
#
# frozen_string_literal: true

composer_auth = ConfigHelper.value('application/authentication/composer')
composer_app = ConfigHelper.value('infrastructure/composer')
settings_arr = [composer_auth, composer_app]

override[:composer][:version] = composer_app if composer_app.is_a?(String)
settings_arr.each do |setting|
	if setting.is_a?(Hash)
		setting.each { |key, value| override[:composer][key] = value }
	end
end
