require_relative 'config'

class Hypervisor
	def Hypervisor.value
		Config.hypervisor
	end

	def Hypervisor.list
		Config.hypervisor_list
	end

	def Hypervisor.plugins
		case value
		when 'virtualbox'
		when 'vmware_fusion'
			%w[vagrant-vmware-desktop]
		end
	end
end
