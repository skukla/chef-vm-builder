# Cookbook:: helpers
# Library:: magento_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

module MagentoHelper
	def self.get_consumer_list
		@family = Chef.node[:magento][:options][:family]
		@community_consumer_list =
			Chef.node[:magento][:build][:community_consumer_list]
		@enterprise_consumer_list =
			Chef.node[:magento][:build][:enterprise_consumer_list]
		@user_consumer_list = Chef.node[:magento][:build][:consumer_list]

		@consumer_list =
			@community_consumer_list.each_with_object([]) { |item, arr| arr << item }
		if @family == 'enterprise'
			@enterprise_consumer_list.each { |consumer| @consumer_list << consumer }
		end
		@user_consumer_list.each { |consumer| @consumer_list << consumer }

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
