require_relative 'config'

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
		return Config.base_box unless Config.base_box.nil?

		'bento/ubuntu-21.10' unless RUBY_PLATFORM.include?('x86')
		'bytesguy/ubuntu-server-21.10-arm64' if RUBY_PLATFORM.include?('x86')
	end
end
