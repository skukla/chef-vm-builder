require 'pathname'
require 'json'

class Config
	class << self
		attr_reader :app_root, :build_action_arr
	end
	@app_root = "/#{File.join(Pathname.new(__dir__).each_filename.to_a[0...-2])}"
	@build_action_arr = %i[install force_install restore reinstall update refresh]

	def Config.json
		JSON.parse(File.read(File.join(@app_root, 'config.json')))
	end

	def Config.build_action_list
		@build_action_arr.map { |build_action| build_action.to_s }
	end

	def Config.setting(value)
		json.dig(*value.split('/'))
	end
end
