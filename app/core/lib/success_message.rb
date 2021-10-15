require_relative 'message'

class SuccessMsg < Message
	def SuccessMsg.show(message_code)
		super
	end

	def SuccessMsg.plugins_installed
		msg = <<~TEXT
    #{@@success}Plugins have been installed. Please run the #{@@bold}#{@@cyan}vagrant up #{@@reg}command \
    again to continue.
    TEXT
	end

	def SuccessMsg.elasticsearch_available
		msg = <<~TEXT
    #{@@success}Elasticsearch is available.
    TEXT
	end

	def SuccessMsg.ssl_keys_removed_from_keychain; end

	def SuccessMsg.ssl_keys_removed_from_system; end

	def SuccessMsg.ssl_key_added; end
end
