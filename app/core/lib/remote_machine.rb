require_relative 'system'
require_relative 'config'

class Remote_Machine
	def Remote_Machine.ip_address(vm)
		System.cmd(
			"vagrant ssh #{vm.name} -c 'echo $(hostname -I) | grep -o \"[^ ]*$\"'",
		).chomp
	end

	def Remote_Machine.vm_id(vm)
		if Config.hypervisor == 'vmware_fusion'
			arr = vm.id.split('/')
			return arr[arr.length - 2]
		end

		vm.id
	end
end
