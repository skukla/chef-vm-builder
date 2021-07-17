require_relative 'config'

class Entry
	@entries_to_remove = %w[. .. .DS_Store .gitignore]

	def Entry.path(path_str)
		File.join(Config.app_root, path_str)
	end

	def Entry.files_from(file_path)
		Dir.entries("#{File.join(Config.app_root, file_path)}") - @entries_to_remove
	end
end
