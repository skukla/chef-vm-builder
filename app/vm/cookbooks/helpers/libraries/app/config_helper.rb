# Cookbook:: helpers
# Library:: app/config_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

require 'pathname'
require 'json'

class ConfigHelper
	class << self
		attr_reader :app_root, :build_action_arr
	end
	@app_root = '/var/chef/cache/cookbooks'

	def ConfigHelper.remove_blanks(hash_or_array)
		p =
			proc do |*args|
				v = args.last
				v.delete_if(&p) if v.respond_to? :delete_if
				v.nil? || v.respond_to?(:'empty?') && v.empty?
			end
		hash_or_array.delete_if(&p)
	end

	def ConfigHelper.json
		self.remove_blanks(
			JSON.parse(
				File.read(
					File.join("#{@app_root}/helpers/libraries/app", 'config.json'),
				),
			),
		)
	end

	def ConfigHelper.value(setting_path)
		json.dig(*setting_path.split('/'))
	end

	def ConfigHelper.setting(path, key = nil)
		setting = value(path)

		if setting.nil? || setting.empty? ||
				(setting.is_a?(Hash) && (setting[key].nil? || setting[key].to_s.empty?))
			return nil
		end

		return setting[key] if (setting.is_a?(Hash) && !setting[key].to_s.empty?)

		setting if setting.is_a?(String)
	end

	def ConfigHelper.hypervisor
		setting('vm/hypervisor')
	end

	def ConfigHelper.search_engine_type
		setting('infrastructure/search_engine', 'type')
	end

	def ConfigHelper.url_protocol
		usf = value('application/settings/use_secure_frontend')
		usa = value('application/settings/use_secure_admin')
		return 'http://' if usf.nil? || usa.nil?
		!usf.zero? || usa.zero? ? 'https://' : 'http://'
	end
end
