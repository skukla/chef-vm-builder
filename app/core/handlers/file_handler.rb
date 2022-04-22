require 'json'

require_relative '../lib/config'

class FileHandler
	def FileHandler.append_to_file(path, content)
		File.open(File.join(path), 'w+') { |file| file.puts(content) }
	end

	def FileHandler.create_environment_file
		env_file_path = File.join(Config.app_root, 'app/vm/environments/vm.json')
		env_file_content = {
			name: 'vm',
			description: 'Configuration file for the Kukla Demo VM',
			default_attributes: {},
			override_attributes: Config.json,
			chef_type: 'environment',
		}.to_json
		append_to_file(env_file_path, env_file_content)
	end
end