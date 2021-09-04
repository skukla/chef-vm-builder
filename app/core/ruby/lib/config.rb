require 'pathname'
require 'json'

class Config
	class << self
		attr_reader :app_root, :build_action_arr
	end
	@app_root = "/#{File.join(Pathname.new(__dir__).each_filename.to_a[0...-4])}"

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

	def Config.value(setting_path)
		json.dig(*setting_path.split('/'))
	end
end
