require 'pathname'
require 'json'

class ConfigHelper
	class << self
		attr_reader :app_root, :build_action_arr
	end
	@app_root = '/var/chef/cache/cookbooks'
	@build_action_arr = %i[
		install
		force_install
		restore
		reinstall
		update_all
		update_app
		update_data
	]

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

	def ConfigHelper.build_action_list
		@build_action_arr.map { |build_action| build_action.to_s }
	end

	def ConfigHelper.value(setting_path)
		json.dig(*setting_path.split('/'))
	end
end
