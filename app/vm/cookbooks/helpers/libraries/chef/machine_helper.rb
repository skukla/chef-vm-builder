# Cookbook:: helpers
# Library:: chef/machine_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class MachineHelper
	def MachineHelper.ip_address
		SystemHelper.cmd(
			"ifconfig eth1 | grep \"inet \" | awk '{print $2}' | tr -d '\n'",
		)
	end
end
