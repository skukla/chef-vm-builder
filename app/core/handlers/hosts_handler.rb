require_relative '../lib/remote_machine'
require_relative '../lib/demo_structure'
require_relative '../lib/info_message'

class HostsHandler
	def HostsHandler.manage_hosts(config)
		config.hostmanager.enabled = true
		config.hostmanager.manage_host = true
		config.hostmanager.manage_guest = true
		config.hostmanager.ignore_private_ip = false
		config.hostmanager.include_offline = true
		config.hostmanager.aliases = DemoStructure.additional_urls
		config.hostmanager.ip_resolver =
			proc do |vm, _resolving_vm|
				if hostname = (vm.ssh_info && vm.ssh_info[:host])
					Remote_Machine.ip_address(vm)
				end
			end
	end
end
