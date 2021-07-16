require_relative 'config'

class VagrantPlugin
	class << self
		attr_accessor :list
		attr_reader :required_plugins
	end
	@list = Config.setting('vagrant/plugins')
	@required_plugins = %w[vagrant-hostsupdater]

	def VagrantPlugin.installed_plugins
		`vagrant plugin list`.split(' ').select do |plugin_str|
			plugin_str.include?('vagrant')
		end
	end
end
