# Cookbook:: helpers
# Library:: chef/magento_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class MagentoHelper
	def MagentoHelper.get_base_version(version)
		version.include?('-p') ? version.sub(/.{3}$/, '') : version
	end

	def MagentoHelper.check_version(lower_bound, operator, upper_bound)
		Gem::Version
			.new(MagentoHelper.get_base_version(lower_bound))
			.send(operator, Gem::Version.new(upper_bound))
	end

	def MagentoHelper.build_command_list(type)
		return if Chef.node[:magento][:build][:hooks][:commands].nil?

		commands = Chef.node[:magento][:build][:hooks][:commands]
		case type
		when :vm_cli
			commands.reject { |command| command.include?(':') }
		when :magento_cli
			commands.select { |command| command.include?(':') }
		end
	end
end
