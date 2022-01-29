require_relative '../lib/config'

class HypervisorHandler
	@hypervisor = Config.hypervisor

	def HypervisorHandler.configure_network(machine)
		case @hypervisor
		when 'virtualbox'
			machine.vm.network 'private_network', ip: Config.value('vm/ip')
		end
	end

	def HypervisorHandler.customize_vm(machine)
		case @hypervisor
		when 'virtualbox'
			machine.default_nic_type = '82543GC'
			machine.customize [
					'modifyvm',
					:id,
					'--name',
					Config.value('vm/name'),
					'--memory',
					Config.value('remote_machine/memory'),
					'--cpus',
					Config.value('remote_machine/cpus'),
					'--vram',
					'16',
					'--vrde',
					'off',
			                  ]
		end
	end
end
