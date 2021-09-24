class Message
	@@format = "\n%s\n"

	def Message.show(message_code)
		sprintf(@@format, self.send(message_code.to_s))
	end
end
