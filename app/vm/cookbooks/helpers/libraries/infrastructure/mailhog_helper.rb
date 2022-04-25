# Cookbook:: helpers
# Library:: chef/mailhog_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class MailhogHelper
	def MailhogHelper.install_cmd(repository_url)
		case MachineHelper.os_codename
		when 'bionic'
			"go get #{repository_url}"
		else
			"go install #{repository_url}@latest"
		end
	end
end
