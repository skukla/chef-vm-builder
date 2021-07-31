# Cookbook:: helpers
# Library:: module_list_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

module ModuleListHelper
	def self.clean_up_module_data(module_directory)
		`cd #{module_directory} && find . -name '.DS_Store' -type f -delete`
		puts '.DS_Store files removed'

		`cd #{module_directory} && find . -name '.gitignore' -type f -delete`
		puts '.gitignore files removed'
	end
end
