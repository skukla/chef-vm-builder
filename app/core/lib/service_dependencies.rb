require_relative 'system'

class ServiceDependencies
	def ServiceDependencies.xcode_missing?
		!Dir.exist?('/Library/Developer/CommandLineTools')
	end

	def ServiceDependencies.homebrew_missing?
		!File.exist?('/usr/local/bin/brew')
	end
end
