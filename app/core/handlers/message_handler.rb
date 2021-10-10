require_relative '../lib/info_message'

class MessageHandler
	def MessageHandler.after_run_info
		print InfoMsg.url_info
	end
end
