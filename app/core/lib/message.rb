require_relative 'text_formatter'
require_relative 'config'

class Message
	@@format = "\n%s\n"
	@@bold = TextFormatter.value[:bold]
	@@reg = TextFormatter.value[:reg]
	@@cyan = TextFormatter.value[:cyan]
	@@magenta = TextFormatter.value[:magenta]
	@@green = TextFormatter.value[:green]
	@@start_underline = TextFormatter.value[:enter_underline]
	@@stop_underline = TextFormatter.value[:exit_underline]
	@@oops = "#{@@bold}#{@@magenta}[OOPS]: #{@@reg}"
	@@success = "#{@@bold}#{@@green}[SUCCESS]: #{@@reg}"
	@@info = "#{@@bold}==> Kukla-Machine: #{@@bold}"

	def Message.show(message_code)
		sprintf(@@format, self.send(message_code.to_s))
	end
end
