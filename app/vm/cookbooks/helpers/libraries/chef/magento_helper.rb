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
			.new(get_base_version(lower_bound))
			.send(operator, Gem::Version.new(upper_bound))
	end

	def MagentoHelper.define_family(family)
		return 'community' if family == 'Open Source'
		return 'enterprise' if family == 'Commerce'
		family
	end

	def MagentoHelper.build_install_string(
		build_action,
		version,
		search_engine_type,
		db_settings,
		install_settings
	)
		install_str =
			[
				"--db-host=#{db_settings[:db_host]}",
				"--db-name=#{db_settings[:db_name]}",
				"--db-user=#{db_settings[:db_user]}",
				"--db-password=#{db_settings[:db_password]}",
			].join(' ')

		install_str =
			[
				install_str,
				"--backend-frontname=#{install_settings[:backend_frontname]}",
				"--base-url=#{install_settings[:unsecure_base_url]}",
				"--language=#{install_settings[:language]}",
				"--timezone=#{install_settings[:timezone]}",
				"--currency=#{install_settings[:currency]}",
				"--elasticsearch-host=#{install_settings[:elasticsearch_host]}",
				"--elasticsearch-port=#{install_settings[:elasticsearch_port]}",
				"--elasticsearch-index-prefix=#{install_settings[:elasticsearch_prefix]}",
				"--admin-firstname=#{install_settings[:admin_firstname]}",
				"--admin-lastname=#{install_settings[:admin_lastname]}",
				"--admin-email=#{install_settings[:admin_email]}",
				"--admin-user=#{install_settings[:admin_user]}",
				"--admin-password=#{install_settings[:admin_password]}",
				"--use-rewrites=#{ValueHelper.process_value(install_settings[:use_rewrites])}",
				"--use-secure=#{ValueHelper.process_value(install_settings[:use_secure_frontend])}",
				"--use-secure-admin=#{ValueHelper.process_value(install_settings[:use_secure_admin])}",
				"--session-save=#{install_settings[:session_save]}",
			].join(' ')

		if install_settings[:use_secure_frontend] ||
				install_settings[:use_secure_admin]
			install_str = [install_str, install_settings[:secure_url]].join(' ')
		end

		if install_settings[:cleanup_database] == 1
			install_str = [install_str, '--cleanup-database'].join(' ')
		end

		unless install_settings[:encryption_key].to_s.empty?
			install_str =
				[install_str, "--key=#{install_settings[:encryption_key]}"].join(' ')
		end
	end

	def MagentoHelper.get_consumer_list()
		family = Chef.node[:magento][:options][:family]
		community_consumer_list =
			Chef.node[:magento][:build][:community_consumer_list]
		enterprise_consumer_list =
			Chef.node[:magento][:build][:enterprise_consumer_list]

		return community_consumer_list if family == 'community'

		community_consumer_list + enterprise_consumer_list
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

	def MagentoHelper.config_php
		File.join(
			Chef.node[:magento][:nginx][:web_root],
			'app',
			'etc',
			'config.php',
		)
	end

	def MagentoHelper.live_search_enabled?
		StringReplaceHelper.find_in_file(config_php, "'Magento_LiveSearch' => 1")
	end

	def MagentoHelper.switch_search_modules
		ls_module_list =
			Chef.node[:magento][:search_engine][:live_search][:module_list]
		es_module_list =
			Chef.node[:magento][:search_engine][:elasticsearch][:module_list]
		search_engine_type = Chef.node[:magento][:search_engine][:type]

		if (search_engine_type == 'live_search' && live_search_enabled?) ||
				(search_engine_type == 'elasticsearch' && !live_search_enabled?)
			p 'No module changes made.'

			return
		end

		if search_engine_type == 'elasticsearch' && live_search_enabled?
			ls_module_list.each do |ls_module|
				StringReplaceHelper.replace_in_file(
					config_php,
					"'#{ls_module}' => 1",
					"'#{ls_module}' => 0,",
				)
			end

			es_module_list.each do |es_module|
				StringReplaceHelper.replace_in_file(
					config_php,
					"'#{es_module}' => 0",
					"'#{es_module}' => 1,",
				)
			end

			p 'Switched search to elastcsearch.'
		end

		if search_engine_type == 'live_search' && !live_search_enabled?
			ls_module_list.each do |ls_module|
				StringReplaceHelper.replace_in_file(
					config_php,
					"'#{ls_module}' => 0",
					"'#{ls_module}' => 1,",
				)
			end

			es_module_list.each do |es_module|
				StringReplaceHelper.replace_in_file(
					config_php,
					"'#{es_module}' => 1",
					"'#{es_module}' => 0,",
				)
			end

			p 'Switched search to live_search.'
		end
	end
end
