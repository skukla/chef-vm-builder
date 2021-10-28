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

		if search_engine_type == 'elasticsearch' &&
				check_version(version, '>=', '2.4.0')
			install_str =
				[
					install_str,
					"--elasticsearch-host=#{install_settings[:elasticsearch_host]}",
					"--elasticsearch-port=#{install_settings[:elasticsearch_port]}",
					"--elasticsearch-index-prefix=#{install_settings[:elasticsearch_prefix]}",
				].join(' ')
		end

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
