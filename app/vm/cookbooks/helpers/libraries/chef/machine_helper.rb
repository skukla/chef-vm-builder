# Cookbook:: helpers
# Library:: chef/machine_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class MachineHelper
	def MachineHelper.ip_address
		SystemHelper.cmd("echo $(hostname -I) | grep -o \"[^ ]*$\"").chomp
	end

	def MachineHelper.os_codename
		label = 'UBUNTU_CODENAME='
		SystemHelper
			.cmd("cat /etc/os-release | grep #{label}")
			.chomp
			.gsub(label, '')
	end
end
