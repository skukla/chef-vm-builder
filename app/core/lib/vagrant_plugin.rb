require_relative 'system'
require_relative 'hypervisor'

class VagrantPlugin
	class << self
		attr_reader :required_plugins
	end
	@required_plugins = %w[vagrant-hostmanager]

	def VagrantPlugin.installed_plugins
		System
			.cmd('vagrant plugin list')
			.split(' ')
			.select { |plugin_str| plugin_str.include?('vagrant') }
	end

	def VagrantPlugin.list
		list = @required_plugins
		list = list + Hypervisor.plugins unless Hypervisor.plugins.nil?
		list - installed_plugins
	end

	def VagrantPlugin.install
		System.sys_cmd("vagrant plugin install #{list.join(' ')}")
	end
end
