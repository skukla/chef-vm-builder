require_relative 'config'
require_relative 'message'
require_relative 'data_pack'
require_relative 'provider'

class ErrorMsg < Message
  def ErrorMsg.show(message_code)
    super
  end

  def ErrorMsg.config_json_missing
    msg = <<~TEXT
    #{@@oops}It looks like you're missing a #{@@bold}#{@@cyan}config.json #{@@reg}file. \
    Please add one to the #{@@bold}#{@@cyan}projects/config #{@@reg}directory.
    TEXT
  end

  def ErrorMsg.wrong_architecture
    msg = <<~TEXT
    #{@@oops}It looks like you're on an #{@@bold}#{@@cyan}Apple Silicon-based (ARM)#{@@reg} system and trying to use #{@@bold}#{@@cyan}Virtualbox as a provider#{@@reg}. \
    Please use #{@@bold}#{@@cyan}vmware_desktop#{@@reg} instead.
    TEXT
  end

  def ErrorMsg.vm_name_missing
    msg = <<~TEXT
    #{@@oops}It looks like your #{@@bold}#{@@cyan}VM Name#{@@reg} is missing. \
    Please check your config.json file.
    TEXT
  end

  def ErrorMsg.provider_missing
    msg = <<~TEXT
		#{@@oops}It looks like your #{@@bold}#{@@cyan}provider#{@@reg} setting is \
		#{@@bold}#{@@cyan}missing #{@@reg}or #{@@bold}#{@@cyan}empty#{@@reg}. Please check your config.json file.
    TEXT
  end

  def ErrorMsg.provider_incorrect
    provider = Provider.value
    provider_list = Provider.list
    msg = <<~TEXT
    #{@@oops}It looks like you've got an incorrect provider setting: #{@@bold}#{@@cyan}#{provider}#{@@reg}.\n\n\
    Acceptable values are:\n\n#{provider_list.join("\n")}\n\nPlease check your config.json file.
    TEXT
  end

  def ErrorMsg.composer_credentials_missing
    msg = <<~TEXT
		#{@@oops}It looks like you're missing your #{@@bold}#{@@cyan}composer keys #{@@reg}or \
		#{@@bold}#{@@cyan}github oauth token#{@@reg}. Please check your config.json file.
    TEXT
  end

  def ErrorMsg.website_structure_missing
    msg = <<~TEXT
		#{@@oops}It looks like you either don't have a #{@@bold}#{@@cyan}custom_demo/structure#{@@reg} section, or \
		your #{@@bold}#{@@cyan}custom_demo/structure #{@@reg}doesn't contain a\n#{@@bold}#{@@cyan}websites array#{@@reg} with properly defined \
		website, store, and store view information. Please check your config.json file.
    TEXT
  end

  def ErrorMsg.base_website_missing
    msg = <<~TEXT
    #{@@oops}It looks like your #{@@bold}#{@@cyan}structure#{@@reg} doesn't contain a website with a code of \
    #{@@bold}#{@@cyan}base#{@@reg}. Please check your config.json file.
    TEXT
  end

  def ErrorMsg.build_action_missing
    msg = <<~TEXT
		#{@@oops}It looks like your #{@@bold}#{@@cyan}build action#{@@reg} is \
		#{@@bold}#{@@cyan}missing #{@@reg}or #{@@bold}#{@@cyan}empty#{@@reg}. Please check your config.json file.
    TEXT
  end

  def ErrorMsg.build_action_incorrect
    build_action = Config.build_action
    build_action_list = Config.build_action_list
    msg = <<~TEXT
    #{@@oops}It looks like you've got an incorrect build action setting: #{@@bold}#{@@cyan}#{build_action}#{@@reg}.\n\n\
    Acceptable values are:\n\n#{build_action_list.join("\n")}\n\nPlease check your config.json file.
    TEXT
  end

  def ErrorMsg.restore_mode_incorrect
    restore_mode = Config.restore_mode
    restore_mode_list = Config.restore_mode_list
    msg = <<~TEXT
    #{@@oops}It looks like you've got an incorrect restore mode setting: #{@@bold}#{@@cyan}#{restore_mode}#{@@reg}.\n\n\
    Acceptable values are:\n\n#{restore_mode_list.join("\n")}\n\nPlease check your config.json file.
    TEXT
  end

  def ErrorMsg.nothing_to_restore
    msg = <<~TEXT
    #{@@oops}It looks like you're trying to #{@@bold}#{@@cyan}restore a backup#{@@reg}, but there are #{@@bold}#{@@cyan}no backup files#{@@reg}\nin your #{@@bold}#{@@cyan}project/backup#{@@reg} folder.
    TEXT
  end

  def ErrorMsg.search_engine_type_incorrect
    search_engine_type = Config.search_engine_type
    search_engine_type_list = Config.search_engine_type_list
    msg = <<~TEXT
    #{@@oops}It looks like you've got an incorrect search engine setting: #{@@bold}#{@@cyan}#{search_engine_type}#{@@reg}.\n\n\
    Acceptable values are:\n\n#{search_engine_type_list.join("\n")}\n\nPlease check the #{@@bold}#{@@cyan}infrastructure/search_engine #{@@reg}section in your config.json file.
    TEXT
  end

  def ErrorMsg.xcode_missing
    msg = <<~TEXT
		#{@@oops}It looks like #{@@bold}#{@@cyan}Xcode tools#{@@reg} are not installed.\n\n\
		Run the following in a terminal and then follow the GUI to install it:\n\n\
		xcode-select --install
    TEXT
  end

  def ErrorMsg.homebrew_missing
    msg = <<~TEXT
		#{@@oops}It looks like #{@@bold}#{@@cyan}Homebrew#{@@reg} is not installed.\n\n\
		Run the following in a terminal to install it:\n\n\
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    TEXT
  end

  def ErrorMsg.elasticsearch_unavailable
    msg = <<~TEXT
		#{@@oops}It looks like #{@@bold}#{@@cyan}Elasticsearch #{@@reg} isn't available yet. \
		Please try your build again.
    TEXT
  end

  def ErrorMsg.data_pack_installer_missing
    msg = <<~TEXT
		#{@@oops}You've specified a data pack but it looks like you're missing the \
		#{@@bold}#{@@cyan}data install custom module #{@@reg}\nor have the wrong values for it \
		in your config.json file.
		TEXT
  end

  def ErrorMsg.data_pack_update
    msg = <<~TEXT
		#{@@oops}You have a #{@@bold}#{@@cyan}update_data#{@@reg} build action \
		but no #{@@bold}#{@@cyan}data packs#{@@reg} configured in your config.json file.
		TEXT
  end

  def ErrorMsg.data_pack_bad_format
    msg = <<~TEXT
		#{@@oops}It looks like one of your #{@@bold}#{@@cyan}data packs#{@@reg} isn't \
		formatted correctly. \n\n\
		Each data pack definition should have \
		#{@@bold}#{@@cyan}source#{@@reg} and #{@@bold}#{@@cyan}path#{@@reg} fields with optional\n\
		#{@@bold}#{@@cyan}site_code#{@@reg}, and/or \
		#{@@bold}#{@@cyan}store_view_code#{@@reg} fields like: \
		\n\n"source":\s"value",\
		\n"data":\s[\n\s\s{\
		\n\s\s\s\s"path": "value",\
		\n\s\s\s\s"site_code": "value",\
		\n\s\s\s\s"store_view_code": "value",\
		\n\s\s}\
		\n]
		TEXT
  end

  def ErrorMsg.data_pack_source_folders_missing
    msg = <<~TEXT
		#{@@oops}It looks like you're missing the following folders for a \
		#{@@bold}#{@@cyan}data pack #{@@reg}in your #{@@bold}#{@@cyan}projects #{@@reg}directory:\n\n\
		#{@@bold}#{@@cyan}#{DataPack.packs_missing_source_folders.join("\n")}
		TEXT
  end

  def ErrorMsg.data_pack_path_folders_missing
    head = "#{@@oops} It looks your data packs have the following errors:\n\n"

    body =
      DataPack
        .packs_missing_path_folders
        .each_with_object([]) do |pack, arr|
          arr << [
            "You need to create the following folders in the #{@@bold}#{@@cyan}#{pack['source']} #{@@reg}pack's data folder\
						\nto match your configuration in config.json:\n\n",
            "#{@@bold}#{@@cyan}#{pack['paths'].join("\n")}#{@@reg}\n\n",
          ]
        end

    msg = [head, body].join
  end

  def ErrorMsg.data_pack_spaces_in_names
    msg = <<~TEXT
		#{@@oops}It looks like the following data pack path folders have bad names:\n\n#{@@bold}#{@@cyan}'#{DataPack.packs_with_spaces_in_names.join("\n")}'\n\n\
		#{@@reg}Only #{@@bold}#{@@cyan}letters#{@@reg}, #{@@bold}#{@@cyan}numbers#{@@reg}, #{@@bold}#{@@cyan}dashes#{@@reg}, and \
		#{@@bold}#{@@cyan}underscores#{@@reg} are allowed.		
		TEXT
  end

  def ErrorMsg.backup_files_missing
    msg = <<~TEXT
		#{@@oops}It looks like you're trying to #{@@bold}#{@@cyan}restore a backup#{@@reg} but you're \
		#{@@bold}#{@@cyan}missing backup files#{@@reg}. You either need a zip file or a\ncombination of\
		 a database dump, codebase file, and media file like this: \n\n\
		1634001153_db.sql
		1634001153_code.tgz
		1634001153_media.tgz
		TEXT
  end

  def ErrorMsg.csc_credentials_missing
    msg = <<~TEXT
		#{@@oops}It looks like you're trying to configure commerce services but you're missing your \
		#{@@bold}#{@@cyan}Production API Key#{@@reg} \nor it's not formmatted properly. \
		\n\nPlease check your composer.json and make sure you have at least the following \
		configured beneath the composer\nconfiguration in your \
		#{@@bold}#{@@cyan}application/authentication#{@@reg} section:\n\n\
		commerce_services: {\n\
		\s\sproduction_api_key: "value"\n\
		}\n
		TEXT
  end

  def ErrorMsg.csc_keys_missing
    msg = <<~TEXT
    It looks like you're trying to configure commerce services but you're missing both your \
    #{@@bold}#{@@cyan}commerce services sandbox key file#{@@reg} and your \ 
    #{@@bold}#{@@cyan}commerce services production key file#{@@reg}. \n\nPlease make sure a file consisting of your \
    sandbox private key called #{@@bold}#{@@cyan}privateKey-sandbox.pem#{@@reg} and a file consisting of your\n\
    production private key called #{@@bold}#{@@cyan}privateKey-production.pem#{@@reg} are both present inside of \
    your #{@@bold}#{@@cyan}project/keys directory#{@@reg}.
		TEXT
  end

  def ErrorMsg.csc_sandbox_key_missing
    msg = <<~TEXT
		It looks like you're trying to configure commerce services but you're missing your \
		#{@@bold}#{@@cyan}commerce services sandbox key file#{@@reg}.\nPlease make sure a file consisting of your \
		sandbox private key called #{@@bold}#{@@cyan}privateKey-sandbox.pem #{@@reg}is present inside of \
		your\n#{@@bold}#{@@cyan}project/keys directory#{@@reg}.
		TEXT
  end

  def ErrorMsg.csc_production_key_missing
    msg = <<~TEXT
		It looks like you're trying to configure commerce services but you're missing your \
		#{@@bold}#{@@cyan}commerce services production key file#{@@reg}.\nPlease make sure a file consisting of your \
		production private key called #{@@bold}#{@@cyan}privateKey-production.pem #{@@reg}is present inside of \
		your\n#{@@bold}#{@@cyan}project/keys directory#{@@reg}.
		TEXT
  end
end
