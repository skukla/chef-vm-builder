require_relative '../lib/system'

class SystemHandler
	def SystemHandler.clear_screen
		System.cmd('clear')
	end
end
