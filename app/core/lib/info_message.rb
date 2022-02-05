require_relative 'message'

class InfoMsg < Message
	def InfoMsg.show(message_code)
		super
	end

	def InfoMsg.output(message)
		msg = <<~TEXT
    #{@@info}#{message}#{@@reg}
    TEXT
	end
end
