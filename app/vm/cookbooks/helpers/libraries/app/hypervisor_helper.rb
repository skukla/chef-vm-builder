# Cookbook:: helpers
# Library:: app/hypervisor_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class HypervisorHelper
	def HypervisorHelper.value
		ConfigHelper.hypervisor
	end

	def HypervisorHelper.elasticsearch_host
		case value
		when 'virtualbox'
			'10.0.2.2'
		when 'vmware_fusion'
			'127.0.0.1'
		end
	end
end
