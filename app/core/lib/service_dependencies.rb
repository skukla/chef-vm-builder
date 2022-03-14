require_relative 'system'

class ServiceDependencies
	def ServiceDependencies.xcode_missing?
		System.cmd('xcode-select -p')
		!$?.exitstatus.zero?
	end

	def ServiceDependencies.homebrew_missing?
		System.cmd('which -s brew')
		!$?.exitstatus.zero?
	end
end
