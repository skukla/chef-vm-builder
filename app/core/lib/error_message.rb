require_relative 'config'
require_relative 'color'
require_relative 'message'
require_relative 'data_pack'

class ErrorMsg < Message
	@bold = Color.value[:bold]
	@reg = Color.value[:reg]
	@magenta = Color.value[:magenta]
	@cyan = Color.value[:cyan]
	@oops = "#{@bold}#{@magenta}[OOPS]: #{@reg}"

	def ErrorMsg.show(message_code)
		super
	end

	def ErrorMsg.composer_credentials_missing
		msg = <<~TEXT
		#{@oops}It looks like you're missing your #{@bold}#{@cyan}composer keys #{@reg}or \
		#{@bold}#{@cyan}github oauth token#{@reg}. Please check your config.json file.
    TEXT
	end

	def ErrorMsg.website_structure_missing
		msg = <<~TEXT
		#{@oops}It looks like you either don't have a #{@bold}#{@cyan}custom_demo/structure#{@reg} section, or \
		your custom_demo/structure doesn't contain a\n#{@bold}#{@cyan}websites array#{@reg} with properly-defined\
		website, store, and store view information. Please check your config.json file.
    TEXT
	end

	def ErrorMsg.base_website_missing
		msg = <<~TEXT
    #{@oops}It looks like your #{@bold}#{@cyan}structure#{@reg} doesn't contain a website with a code of \
    #{@bold}#{@cyan}base#{@reg}. Please check your config.json file.
    TEXT
	end

	def ErrorMsg.build_action_missing
		msg = <<~TEXT
		#{@oops}It looks like your #{@bold}#{@cyan}build action#{@reg} is \
		#{@bold}#{@cyan}missing #{@reg}or #{@bold}#{@cyan}empty#{@reg}. Please check your config.json file.
    TEXT
	end

	def ErrorMsg.build_action_incorrect
		build_action = Config.value('application/build/action')
		build_action_list = Config.build_action_list
		msg = <<~TEXT
    #{@oops}It looks like you've got an incorrect build action: #{@bold}#{@cyan}#{build_action}#{@reg}.\n\n\
    Acceptable values are:\n\n#{build_action_list.join("\n")}\n\nPlease check your config.json file.
    TEXT
	end

	def ErrorMsg.xcode_missing
		msg = <<~TEXT
		#{@oops}It looks like #{@bold}#{@cyan}Xcode tools#{@reg} are not installed.
    TEXT
	end

	def ErrorMsg.homebrew_missing
		msg = <<~TEXT
		#{@oops}It looks like #{@bold}#{@cyan}Homebrew#{@reg} is not installed.
    TEXT
	end

	def ErrorMsg.elasticsearch_unavailable
		msg = <<~TEXT
		#{@oops}It looks like #{@bold}#{@cyan}Elasticsearch #{@reg} isn't available yet. \
		Please try your build again.
    TEXT
	end

	def ErrorMsg.data_pack_installer_missing
		msg = <<~TEXT
		#{@oops}You've specified a data pack but it looks like you're missing the \
		#{@bold}#{@cyan}data install custom module #{@reg}or have the wrong values for it \nin your config.json file.
		TEXT
	end

	def ErrorMsg.data_pack_value_missing
		msg = <<~TEXT
		#{@oops}It looks like you're missing a \
		#{@bold}#{@cyan}#{DataPack.required_fields.join("#{@reg} or #{@bold}#{@cyan}")} \
		#{@reg}for a #{@bold}#{@cyan}data pack #{@reg}in your config.json file.
		TEXT
	end

	def ErrorMsg.data_pack_folder_missing
		msg = <<~TEXT
		#{@oops}It looks like you're missing a #{@bold}#{@cyan}folder#{@reg} for a \
		#{@bold}#{@cyan}data pack #{@reg}in your #{@bold}#{@cyan}projects #{@reg}directory.
		TEXT
	end

	def ErrorMsg.data_pack_refresh
		msg = <<~TEXT
		#{@oops}You have a #{@bold}#{@cyan}refresh#{@reg} build action \
		but no #{@bold}#{@cyan}data packs#{@reg} configured in your config.json file.
		TEXT
	end

	def ErrorMsg.csc_extensions_missing
		msg = <<~TEXT
		#{@oops}You've specified commerce services credentials but it looks like you're missing either the \
		#{@bold}#{@cyan}product recommendations\n #{@reg}or the #{@bold}#{@cyan}live search #{@reg}custom module \
		in your config.json file.
		TEXT
	end

	def ErrorMsg.csc_credentials_missing
		msg = <<~TEXT
		It looks like you're trying to configure commerce services but you're missing your \
		#{@bold}#{@cyan}Production API Key#{@reg},\n#{@bold}#{@cyan}Project ID#{@reg}, or \
		#{@bold}#{@cyan}Data Space ID#{@reg}. Please check your composer.json and make sure these items \
		are configured\ninside the #{@bold}#{@cyan}application/authentication/commerce_services #{@reg}section.
		TEXT
	end

	def ErrorMsg.csc_key_missing
		msg = <<~TEXT
		It looks like you're trying to configure commerce services but you're missing your \
		#{@bold}#{@cyan}commerce services production key file#{@reg}.\nPlease make sure a file consisting of your \
		production key called #{@bold}#{@cyan}privateKey-production.pem #{@reg}is present inside of \
		your\n#{@bold}#{@cyan}project/keys directory#{@reg}.
		TEXT
	end

	def ErrorMsg.backup_files_missing; end
end
