# Cookbook:: helpers
# Library:: app/message_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class MessageHelper
  def MessageHelper.displayUrls(admin_path, mailhog_port)
    msg = <<~TEXT
		=====================================================================

		Storefront Access\n\
		-----------------
		#{DemoStructureHelper.vm_urls_with_protocol('storefront').join("\n")}

		Admin Access and Mailbox\n\
		------------------------
		#{DemoStructureHelper.base_url_with_protocol('admin')}/#{admin_path}
		#{DemoStructureHelper.base_url_with_protocol}:#{mailhog_port}\n\

		VM Access\n\
		---------
		Use vagrant ssh to access the VM's operating system and CLI
		
		=====================================================================
		TEXT
    print msg
  end
end
