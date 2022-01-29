require_relative 'config'

class Hypervisor
	@hypervisor = Config.hypervisor

	def Hypervisor.configure_network(machine)
		case @hypervisor
		when 'virtualbox'
			machine.vm.network 'private_network', ip: Config.value('vm/ip')
		when 'vmware_fusion'
			machine.vm.network 'private_network'
		end
	end

	def Hypervisor.customize_vm(machine)
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
		when 'vmware_fusion'
			machine.vmx['displayName'] = Config.value('vm/name')
			machine.vmx['memsize'] = Config.value('remote_machine/memory')
			machine.vmx['numvcpus'] = Config.value('remote_machine/cpus')
			machine.vmx['ethernet0.pcislotnumber'] = '33'
		end
	end

	def Hypervisor.plugins
		case @hypervisor
		when 'virtualbox'
		when 'vmware_fusion'
			%w[vagrant-vmware-desktop]
		end
	end
end
