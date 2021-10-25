require_relative 'config'
require_relative 'message'
require_relative 'data_pack'

class ErrorMsg < Message
	def ErrorMsg.show(message_code)
		super
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
		your custom_demo/structure doesn't contain a\n#{@@bold}#{@@cyan}websites array#{@@reg} with properly-defined\
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

	def ErrorMsg.search_engine_type_missing
		msg = <<~TEXT
		#{@@oops}It looks like your #{@@bold}#{@@cyan}search engine type#{@@reg} is \
		#{@@bold}#{@@cyan}missing #{@@reg}or #{@@bold}#{@@cyan}empty#{@@reg}. Please check your config.json file.
    TEXT
	end

	def ErrorMsg.search_engine_type_incorrect
		search_engine_type = Config.search_engine_type
		search_engine_type_list = Config.search_engine_type_list
		msg = <<~TEXT
    #{@@oops}It looks like you've got an incorrect search engine setting: #{@@bold}#{@@cyan}#{search_engine_type}#{@@reg}.\n\n\
    Acceptable values are:\n\n#{search_engine_type_list.join("\n")}\n\nPlease check the #{@@bold}#{@@cyan}search_engine #{@@reg}section in your config.json file.
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

	def ErrorMsg.data_pack_folder_missing
		msg = <<~TEXT
		#{@@oops}It looks like you're missing a #{@@bold}#{@@cyan}folder#{@@reg} for a \
		#{@@bold}#{@@cyan}data pack #{@@reg}in your #{@@bold}#{@@cyan}projects #{@@reg}directory.
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

	def ErrorMsg.csc_extensions_missing
		msg = <<~TEXT
		#{@@oops}You've specified #{@@bold}#{@@cyan}commerce services credentials#{@@reg} but it looks like you're missing one of the \
		\nrequired custom modules in your config.json file:\n\n#{CommerceServices.required_modules.join("\n")}
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

	def ErrorMsg.csc_key_missing
		msg = <<~TEXT
		It looks like you're trying to configure commerce services but you're missing your \
		#{@@bold}#{@@cyan}commerce services production key file#{@@reg}.\nPlease make sure a file consisting of your \
		production key called #{@@bold}#{@@cyan}privateKey-production.pem #{@@reg}is present inside of \
		your\n#{@@bold}#{@@cyan}project/keys directory#{@@reg}.
		TEXT
	end
end
