# Cookbook:: helpers
# Library:: app/message_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class MessageHelper
	def MessageHelper.displayUrls(mailhog_port)
		msg = <<~TEXT
		\n\n\
		Admin Access and Mailbox\n\
		------------------------
		#{DemoStructureHelper.base_url_with_protocol}/admin
		#{DemoStructureHelper.base_url_with_protocol}:#{mailhog_port}\n\n
		Storefront Access\n\
		-----------------
		#{DemoStructureHelper.vm_urls_with_protocol.join("\n")}
		\n
		TEXT
		print msg
	end
end
