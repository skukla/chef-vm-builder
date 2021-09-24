require_relative '../lib/config'
require_relative '../lib/composer'
require_relative '../lib/error_message'
require_relative '../lib/success_message'
require_relative '../lib/demo_structure'
require_relative '../lib/vagrant_plugin'
require_relative '../lib/data_pack'
require_relative '../lib/custom_module'
require_relative '../lib/entry'
require_relative '../lib/commerce_services'
require_relative '../lib/service_dependencies'

class ValidationHandler
	@build_action = Config.value('application/build/action')

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
		abort(ErrorMsg.show(:build_action_missing)) if @build_action.to_s.empty?

		unless Config.build_action_list.include?(@build_action)
			abort(ErrorMsg.show(:build_action_incorrect))
		end
	end

	def ValidationHandler.plugins
		vagrant_plugin = VagrantPlugin

		if vagrant_plugin.list.to_s.empty?
			vagrant_plugin.list = vagrant_plugin.required_plugins
		end

		return if (vagrant_plugin.list - vagrant_plugin.installed_plugins).empty?

		system("vagrant plugin install #{vagrant_plugin.list.join(' ')}")
		abort(SuccessMsg.show(:plugins_installed))
	end

	def ValidationHandler.service_dependencies
		abort(ErrorMsg.show(:xcode_missing)) if ServiceDependencies.xcode_missing?
		if ServiceDependencies.homebrew_missing?
			abort(ErrorMsg.show(:homebrew_missing))
		end
	end

	def ValidationHandler.data_packs
		return if @build_action == 'restore' || DataPack.list.to_s.empty?

		unless CustomModule.data_installer_found?
			abort(ErrorMsg.show(:data_pack_installer_missing))
		end
		abort(ErrorMsg.show(:data_pack_value_missing)) if DataPack.missing_value?
		abort(ErrorMsg.show(:data_pack_folder_missing)) if DataPack.missing_folder?
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
