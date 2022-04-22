require_relative '../lib/demo_structure'

class HostsHandler
	def HostsHandler.manage_hosts(config)
		config.hostmanager.enabled = true
		config.hostmanager.manage_host = true
		config.hostmanager.manage_guest = false
		config.hostmanager.ignore_private_ip = false
		config.hostmanager.include_offline = false
		config.hostmanager.aliases = DemoStructure.additional_urls
		config.hostmanager.ip_resolver =
			proc do |machine|
				result = ''
				machine
					.communicate
					.execute('hostname -I') do |type, data|
						result << data.split(' ')[1] if type == :stdout
					end
				result
			end
	end
end
