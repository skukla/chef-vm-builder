# Cookbook:: helpers
# Library:: app/system_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class SystemHelper
	def SystemHelper.cmd(command)
		`#{command}`
	end
end
