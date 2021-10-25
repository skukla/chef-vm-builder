require_relative '../lib/system'
require_relative '../lib/entry'
require_relative '../lib/config'
require_relative '../lib/composer'
require_relative '../lib/error_message'
require_relative '../lib/success_message'
require_relative '../lib/demo_structure'
require_relative '../lib/vagrant_plugin'
require_relative '../lib/data_pack'
require_relative '../lib/custom_module'
require_relative '../lib/backup'
require_relative '../lib/commerce_services'
require_relative '../lib/service_dependencies'
require_relative '../lib/elasticsearch'

class ValidationHandler
	@build_action = Config.build_action
	@search_engine_type = Config.search_engine_type
	@restore_mode = Config.restore_mode

	def ValidationHandler.config_json_structure
		if DemoStructure.website_structure_missing?
			abort(ErrorMsg.show(:website_structure_missing))
		end
	end

	def ValidationHandler.composer_credentials
		if Composer.credentials_missing?
			abort(ErrorMsg.show(:composer_credentials_missing))
		end
	end

	def ValidationHandler.base_website
		if DemoStructure.base_website_missing?
			abort(ErrorMsg.show(:base_website_missing))
		end
	end

	def ValidationHandler.build_action
		abort(ErrorMsg.show(:build_action_missing)) if @build_action.nil?

		unless Config.build_action_list.include?(@build_action)
			abort(ErrorMsg.show(:build_action_incorrect))
		end
	end

	def ValidationHandler.restore_mode
		if @build_action != 'restore' ||
				(@build_action == 'restore' && @restore_mode.nil?)
			return
		end

		unless Config.restore_mode_list.include?(@restore_mode)
			abort(ErrorMsg.show(:restore_mode_incorrect))
		end
	end

	def ValidationHandler.search_engine_type
		if @search_engine_type.nil?
			abort(ErrorMsg.show(:search_engine_type_missing))
		end

		unless Config.search_engine_type_list.include?(@search_engine_type)
			abort(ErrorMsg.show(:search_engine_type_incorrect))
		end
	end

	def ValidationHandler.plugins
		vagrant_plugin = VagrantPlugin

		if vagrant_plugin.list.nil?
			vagrant_plugin.list = vagrant_plugin.required_plugins
		end

		return if (vagrant_plugin.list - vagrant_plugin.installed_plugins).empty?

		System.install_vagrant_plugins(vagrant_plugin.list)

		abort(SuccessMsg.show(:plugins_installed))
	end

	def ValidationHandler.service_dependencies
		abort(ErrorMsg.show(:xcode_missing)) if ServiceDependencies.xcode_missing?
		if ServiceDependencies.homebrew_missing?
			abort(ErrorMsg.show(:homebrew_missing))
		end
	end

	def ValidationHandler.data_packs
		return if @build_action == 'restore'
		return if DataPack.list.empty?
		if DataPack.list.empty? && @build_action == 'update_data'
			abort(ErrorMsg.show(:data_pack_update))
		end
		unless CustomModule.data_installer_found?
			abort(ErrorMsg.show(:data_pack_installer_missing))
		end
		abort(ErrorMsg.show(:data_pack_bad_format)) if DataPack.data_format_error?
		abort(ErrorMsg.show(:data_pack_folder_missing)) if DataPack.missing_folder?
	end

	def ValidationHandler.backups
		return unless @build_action == 'restore'

		if Entry.files_from('project/backup').empty?
			abort(ErrorMsg.show(:nothing_to_restore))
		end

		abort(ErrorMsg.show(:backup_files_missing)) if !Backup.files_found?
	end

	def ValidationHandler.csc_credentials
		csc_credentials_missing = CommerceServices.credentials_missing?

		return if csc_credentials_missing.nil?

		abort(ErrorMsg.show(:csc_credentials_missing)) if csc_credentials_missing

		if !csc_credentials_missing &&
				!CustomModule.module_found?(CommerceServices.required_modules)
			abort(ErrorMsg.show(:csc_extensions_missing))
		end

		unless Entry
				.files_from('project/keys')
				.include?('privateKey-production.pem')
			abort(ErrorMsg.show(:csc_key_missing))
		end
	end
end
