require_relative '../lib/entry'
require_relative '../lib/config'
require_relative '../lib/composer'
require_relative '../lib/error_message'
require_relative '../lib/success_message'
require_relative '../lib/vagrant_plugin'
require_relative '../lib/demo_structure'
require_relative '../lib/elasticsearch_depends'
require_relative '../lib/data_pack'
require_relative '../lib/custom_module'
require_relative '../lib/backup'
require_relative '../lib/commerce_services'
require_relative '../lib/provider'

class ValidationHandler
  @build_action = Config.build_action
  @search_engine_type = Config.search_engine_type
  @restore_mode = Config.restore_mode

  def ValidationHandler.validate
    architecture
    config_json
    provider
    plugins
    vm_name
    composer_credentials
    build_action
    site_structure
    local_elasticsearch
    restore_mode
    data_packs
    backups
    csc_credentials
  end

  def ValidationHandler.architecture
    if Provider.value == 'virtualbox' && !GuestMachine.is_intel?
      abort(ErrorMsg.show(:wrong_architecture))
    end
  end

  def ValidationHandler.config_json
    abort(ErrorMsg.show(:config_json_missing)) if Config.json.nil?
  end

  def ValidationHandler.provider
    abort(ErrorMsg.show(:provider_missing)) if Provider.value.nil?

    unless Provider.list.include?(Provider.value)
      abort(ErrorMsg.show(:provider_incorrect))
    end
  end

  def ValidationHandler.plugins
    return if VagrantPlugin.list.empty?

    VagrantPlugin.install
    abort(SuccessMsg.show(:plugins_installed))
  end

  def ValidationHandler.vm_name
    abort(ErrorMsg.show(:vm_name_missing)) if Config.vm_name.nil?
  end

  def ValidationHandler.composer_credentials
    if Composer.credentials_missing?
      abort(ErrorMsg.show(:composer_credentials_missing))
    end
  end

  def ValidationHandler.build_action
    abort(ErrorMsg.show(:build_action_missing)) if @build_action.nil?

    unless Config.build_action_list.include?(@build_action)
      abort(ErrorMsg.show(:build_action_incorrect))
    end
  end

  def ValidationHandler.site_structure
    if DemoStructure.website_structure_missing?
      abort(ErrorMsg.show(:website_structure_missing))
    end

    if DemoStructure.base_website_missing?
      abort(ErrorMsg.show(:base_website_missing))
    end
  end

  def ValidationHandler.search_engine_type
    return if @search_engine_type.nil?

    unless Config.search_engine_type_list.include?(@search_engine_type)
      abort(ErrorMsg.show(:search_engine_type_incorrect))
    end
  end

  def ValidationHandler.local_elasticsearch
    if ElasticsearchDependencies.xcode_missing?
      abort(ErrorMsg.show(:xcode_missing))
    end
    if ElasticsearchDependencies.homebrew_missing?
      abort(ErrorMsg.show(:homebrew_missing))
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

  def ValidationHandler.data_packs
    return if @build_action == 'restore' && @restore_mode == 'separate'
    return if DataPack.list.empty? && @build_action != 'update_data'

    if DataPack.list.empty? && @build_action == 'update_data'
      abort(ErrorMsg.show(:data_pack_update))
    end

    abort(ErrorMsg.show(:data_pack_bad_format)) if DataPack.data_format_error?

    unless DataPack.packs_with_spaces_in_names.empty?
      abort(ErrorMsg.show(:data_pack_spaces_in_names))
    end

    unless DataPack.packs_missing_source_folders.empty?
      abort(ErrorMsg.show(:data_pack_source_folders_missing))
    end

    unless DataPack.packs_missing_path_folders.empty?
      abort(ErrorMsg.show(:data_pack_path_folders_missing))
    end
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

    keys = Entry.files_from('project/keys')
    sandbox_key_file = 'privateKey-sandbox.pem'
    production_key_file = 'privateKey-production.pem'

    if !keys.include?(sandbox_key_file) && !keys.include?(production_key_file)
      abort(ErrorMsg.show(:csc_keys_missing))
    end

    unless keys.include?(sandbox_key_file)
      abort(ErrorMsg.show(:csc_sandbox_key_missing))
    end

    unless keys.include?(production_key_file)
      abort(ErrorMsg.show(:csc_production_key_missing))
    end
  end
end
