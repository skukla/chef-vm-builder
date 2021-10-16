require_relative 'message'
require_relative 'config'
require_relative 'demo_structure'

class InfoMsg < Message
	def InfoMsg.show(message_code)
		super
	end

	def InfoMsg.url_info
		msg = <<~TEXT
		\n\
		#{@@bold}#{@@cyan}#{@@start_underline}Admin Access#{@@stop_underline}#{@@reg}\n\
		#{DemoStructure.base_url_with_protocol}/admin\n\n\
		#{@@bold}#{@@cyan}#{@@start_underline}Storefront Access#{@@stop_underline}#{@@reg}\n\
		#{DemoStructure.vm_urls_with_protocol.join("\n")}\n
		TEXT
	end
end