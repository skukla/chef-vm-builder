# Cookbook:: helpers
# Library:: chef/magento_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class MagentoHelper
	def MagentoHelper.base_version(version)
		version.include?('-p') ? version.sub(/.{3}$/, '') : version
	end

	def MagentoHelper.check_version(lower_bound, operator, upper_bound)
		Gem::Version
			.new(base_version(lower_bound))
			.send(operator, Gem::Version.new(upper_bound))
	end

	def MagentoHelper.family(value = nil)
		unless value.nil?
			return 'community' if value == 'Open Source'
			return 'enterprise' if value == 'Commerce'
		end
		Chef.node[:magento][:options][:family]
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

	def MagentoHelper.consumer_list()
		family = Chef.node[:magento][:options][:family]
		community_consumer_list =
			Chef.node[:magento][:build][:community_consumer_list]
		enterprise_consumer_list =
			Chef.node[:magento][:build][:enterprise_consumer_list]

		return community_consumer_list if family == 'community'

		community_consumer_list + enterprise_consumer_list
	end

	def MagentoHelper.build_hook_command_list(type)
		return if Chef.node[:magento][:build][:hooks][:commands].nil?

		commands = Chef.node[:magento][:build][:hooks][:commands]
		case type
		when :vm_cli
			commands.reject { |command| command.include?(':') }
		when :magento_cli
			commands.select { |command| command.include?(':') }
		end
	end

	def MagentoHelper.web_root
		Chef.node[:magento][:nginx][:web_root]
	end

	def MagentoHelper.tmp_dir
		Chef.node[:magento][:nginx][:tmp_dir]
	end

	def MagentoHelper.composer_json
		File.join(web_root, 'composer.json')
	end

	def MagentoHelper.tmp_composer_json
		File.join(tmp_dir, 'composer.json')
	end

	def MagentoHelper.config_php
		File.join(
			Chef.node[:magento][:nginx][:web_root],
			'app',
			'etc',
			'config.php',
		)
	end

	def MagentoHelper.install_dir
		build_action = Chef.node[:magento][:build][:action]

		tmp_dir if %w[update_all update_app].include?(build_action)
		web_root
	end

	def MagentoHelper.sample_data_flag
		File.join(web_root, 'var', '.sample-data-state.flag')
	end

	def MagentoHelper.live_search_enabled?
		StringReplaceHelper.find_in_file(config_php, "'Magento_LiveSearch' => 1")
	end

	def MagentoHelper.live_search_module_list
		Chef.node[:magento][:search_engine][:live_search][:module_list]
	end

	def MagentoHelper.elasticsearch_module_list
		Chef.node[:magento][:search_engine][:elasticsearch][:module_list]
	end

	def MagentoHelper.search_engine_type
		Chef.node[:magento][:search_engine][:type]
	end

	def MagentoHelper.switch_to_elasticsearch
		live_search_module_list.each do |ls_module|
			StringReplaceHelper.replace_in_file(
				config_php,
				"'#{ls_module}' => 1",
				"\t'#{ls_module}' => 0,",
			)
		end

		elasticsearch_module_list.each do |es_module|
			StringReplaceHelper.replace_in_file(
				config_php,
				"'#{es_module}' => 0",
				"\t'#{es_module}' => 1,",
			)
		end

		p 'Switched search to elastcsearch.'
	end

	def MagentoHelper.switch_to_live_search
		live_search_module_list.each do |ls_module|
			StringReplaceHelper.replace_in_file(
				config_php,
				"'#{ls_module}' => 0",
				"\t'#{ls_module}' => 1,",
			)
		end

		elasticsearch_module_list.each do |es_module|
			StringReplaceHelper.replace_in_file(
				config_php,
				"'#{es_module}' => 1",
				"\t'#{es_module}' => 0,",
			)
		end

		p 'Switched search to live search.'
	end

	def MagentoHelper.switch_search_modules
		if (search_engine_type == 'elasticsearch' && !live_search_enabled?)
			p 'No module changes made.'
		end

		switch_to_live_search if search_engine_type == 'live_search'

		if search_engine_type == 'elasticsearch' && live_search_enabled?
			switch_to_elasticsearch
		end
	end
end