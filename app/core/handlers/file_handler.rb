require 'fileutils'
require 'json'

require_relative '../lib/config'

class FileHandler
	def FileHandler.append_to_file(path, content)
		File.open(File.join(path), 'w+') { |file| file.puts(content) }
	end

	def FileHandler.vm_in_host_file?(vm_id)
		result =
			File.open(File.join('/etc/hosts')) do |file|
				file.find { |line| line =~ /#{vm_id}/ }
			end
		return false if result.nil?
		true
	end

	def FileHandler.update_hosts_file(vm, action)
		ip_address = Remote_Machine.ip_address(vm)
		vm_id = Remote_Machine.vm_id(vm)
		vm_urls = DemoStructure.vm_urls.join(' ')

		case action
		when :add
			System.sys_cmd(
				"echo '#{ip_address} #{vm_urls} # vagrant-#{vm_id}' | sudo tee -a /etc/hosts >/dev/null",
			)
		when :remove
			System.sys_cmd("sudo sed -i '' '/ # vagrant-#{vm_id}$/d' /etc/hosts")
		end
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
