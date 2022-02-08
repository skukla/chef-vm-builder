require_relative 'config'
require_relative 'guest_machine'

class Hypervisor
	def Hypervisor.value
		Config.hypervisor
	end

	def Hypervisor.list
		%w[virtualbox vmware_fusion]
	end

	def Hypervisor.plugins
		case value
		when 'virtualbox'
		when 'vmware_fusion'
			%w[vagrant-vmware-desktop]
		end
	end

	def Hypervisor.base_box
		boxes = {
			'intel' => 'bento/ubuntu-21.10',
			'm1' => 'bytesguy/ubuntu-server-21.10-arm64',
		}

		return Config.base_box unless Config.base_box.nil?

		base_box = boxes['intel'] if GuestMachine.is_intel?
		base_box = boxes['m1'] unless GuestMachine.is_intel?

		base_box
	end
end
