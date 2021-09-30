require 'pathname'
require 'json'

class Config
	class << self
		attr_reader :app_root, :build_action_arr, :search_engine_type_arr
	end
	@app_root = "/#{File.join(Pathname.new(__dir__).each_filename.to_a[0...-3])}"
	@search_setting_path = 'infrastructure/search_engine'

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
		Config.remove_blanks(
			JSON.parse(File.read(File.join(@app_root, 'config.json'))),
		)
	end

	def Config.build_action_list
		@build_action_arr = %i[
			install
			force_install
			restore
			reinstall
			update
			refresh
		]
		@build_action_arr.map { |build_action| build_action.to_s }
	end

	def Config.search_engine_type_list
		@search_engine_type_arr = %i[elastic live]
		@search_engine_type_arr.map { |search_engine_type| search_engine_type.to_s }
	end

	def Config.value(setting_path)
		json.dig(*setting_path.split('/'))
	end

	def Config.search_engine_type
		search_setting = Config.value(@search_setting_path)

		if search_setting.nil? ||
				(search_setting.is_a?(Hash) && search_setting['type'].nil?)
			return nil
		end

		if (search_setting.is_a?(Hash) && search_setting['type'] == 'elastic')
			return search_setting['type']
		end

		search_setting if search_setting.is_a?(String)
	end

	def Config.elasticsearch_requested?
		return true if Config.search_engine_type == 'elastic'
		false
	end

	def Config.wipe_elasticsearch?
		search_setting = Config.value(@search_setting_path)

		if Config.elasticsearch_requested? && search_setting['wipe']
			search_setting['wipe']
		end
	end
end
