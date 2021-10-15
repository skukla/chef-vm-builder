# Cookbook:: helpers
# Library:: app/entry_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class EntryHelper
	@entries_to_remove = %w[. .. .DS_Store .gitignore]

	def EntryHelper.path(path_str)
		File.join(ConfigHelper.app_root, path_str)
	end

	def EntryHelper.files_from(file_path)
		Dir.entries("#{File.join(ConfigHelper.app_root, file_path)}") -
			@entries_to_remove
	end
end
