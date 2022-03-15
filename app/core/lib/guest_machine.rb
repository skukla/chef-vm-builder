require_relative 'system'

class GuestMachine
	def GuestMachine.is_intel?
		System.cmd('uname -m').include?('x86_64')
	end
end
