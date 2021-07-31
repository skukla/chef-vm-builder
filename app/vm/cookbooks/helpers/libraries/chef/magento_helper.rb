#
# Cookbook:: helpers
# Library:: magento_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module MagentoHelper
	def self.get_consumer_list
		@family_override = Chef.node.override['magento']['options']['family']
		@family_default = Chef.node.default['magento']['options']['family']
		@community_consumer_list =
			Chef.node.default['magento']['build']['community_consumer_list']
		@enterprise_consumer_list =
			Chef.node.default['magento']['build']['enterprise_consumer_list']
		@user_consumer_list =
			Chef.node.override['magento']['build']['consumer_list']
		@consumer_list = []

		@family =
			if @family_override.nil? || @family_override.empty?
				@family_default
			else
				@family_override
			end

		if @family == 'enterprise'
			@community_consumer_list.each { |consumer| @consumer_list << consumer }
			@enterprise_consumer_list.each { |consumer| @consumer_list << consumer }
		else
			@user_consumer_list.each { |consumer| @consumer_list << consumer }
		end

		@consumer_list
	end

	def self.get_base_version(version)
		version.include?('-p') ? version.sub(/.{3}$/, '') : version
	end

	def self.check_version(lower_bound, operator, upper_bound)
		Gem::Version
			.new(MagentoHelper.get_base_version(lower_bound))
			.send(operator, Gem::Version.new(upper_bound))
	end

	def self.build_command_list(type)
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
