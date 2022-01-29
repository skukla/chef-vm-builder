require 'pathname'
require 'json'

class Config
	class << self
		attr_reader :app_root,
		            :build_action_arr,
		            :search_engine_type_arr,
		            :restore_mode_arr
	end
	@app_root = "/#{File.join(Pathname.new(__dir__).each_filename.to_a[0...-3])}"
	@search_path = 'infrastructure/search_engine'

	def Config.remove_blanks(hash_or_array)
		p =
			proc do |*args|
				v = args.last
				v.delete_if(&p) if v.respond_to? :delete_if
				v.nil? || v.respond_to?(:'empty?') && v.empty?
			end
		hash_or_array.delete_if(&p)
	end

	def Config.json
		remove_blanks(JSON.parse(File.read(File.join(@app_root, 'config.json'))))
	end

	def Config.value(setting_path)
		json.dig(*setting_path.split('/'))
	end

	def Config.setting(path, key = nil)
		setting = value(path)

		if setting.nil? || setting.empty? ||
				(setting.is_a?(Hash) && (setting[key].nil? || setting[key].to_s.empty?))
			return nil
		end

		return setting[key] if (setting.is_a?(Hash) && !setting[key].to_s.empty?)

		setting if setting.is_a?(String)
	end

	def Config.hypervisor
		setting('vm/hypervisor')
	end

	def Config.build_action
		setting('application/build/action')
	end

	def Config.search_engine_type
		setting(@search_path, 'type')
	end

	def Config.wipe_search_engine?
		setting = setting(@search_path, 'wipe')
		return false unless setting.is_a?(TrueClass) || setting.is_a?(FalseClass)
		setting
	end

	def Config.restore_mode
		setting('application/build/restore', 'mode')
	end

	def Config.build_action_list
		@build_action_arr = %i[
			install
			force_install
			restore
			reinstall
			update_all
			update_app
			update_data
			update_urls
		]
		@build_action_arr.map { |build_action| build_action.to_s }
	end

	def Config.search_engine_type_list
		@search_engine_type_arr = %i[elasticsearch live]
		@search_engine_type_arr.map { |search_engine_type| search_engine_type.to_s }
	end

	def Config.restore_mode_list
		@restore_mode_arr = %i[separate merge]
		@restore_mode_arr.map { |restore_mode| restore_mode.to_s }
	end

	def Config.elasticsearch_requested?
		return true if search_engine_type == 'elasticsearch'
		false
	end

	def Config.url_protocol
		usf = value('application/settings/use_secure_frontend')
		usa = value('application/settings/use_secure_admin')
		return 'http://' if usf.nil? || usa.nil?
		!usf.zero? || usa.zero? ? 'https://' : 'http://'
	end
end
