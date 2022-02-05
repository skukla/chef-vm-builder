require_relative 'system'

class Remote_Machine
	def Remote_Machine.ip_address(vm)
		System.cmd(
			"vagrant ssh #{vm.name} -c 'echo $(hostname -I) | grep -o \"[^ ]*$\"'",
		).chomp
	end
end
