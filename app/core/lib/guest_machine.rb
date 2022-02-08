class GuestMachine
	def GuestMachine.is_intel?
		return false unless RUBY_PLATFORM.include?('x86')
		true
	end
end
