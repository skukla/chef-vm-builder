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
		setting = Config.base_box
		return base_box_list['virtualbox'].first if setting.nil?
		setting
	end

	def Hypervisor.base_box_list
		{
			'virtualbox' => %w[bento/ubuntu-18.04],
			'vmware_fusion' => %w[bento/ubuntu-18.04],
		}
	end
end
