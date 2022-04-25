# Cookbook:: helpers
# Library:: chef/machine_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class MachineHelper
	def MachineHelper.ip_address
		SystemHelper.cmd("echo $(hostname -I) | grep -o \"[^ ]*$\"").chomp
	end

	def MachineHelper.os_codename
		SystemHelper.cmd('lsb_release -cs').chomp
	end

	def MachineHelper.arch
		return 'arm64' unless SystemHelper.cmd('uname -m').include?('x86_64')
		'amd64'
	end
end
