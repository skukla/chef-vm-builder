require_relative 'config'

require 'pathname'

class Entry
	@entries_to_remove = %w[. .. .DS_Store .gitignore .git .vscode]

	def Entry.path(path_str)
		Pathname(File.join(Config.app_root, path_str))
	end

	def Entry.last_slug(path_arr)
		path_arr.split('/').last
	end

	def Entry.files_from(file_path)
		return nil unless File.exist?(path(file_path))

		Dir.entries("#{File.join(Config.app_root, file_path)}") - @entries_to_remove
	end

	def Entry.contains_zip?(file_arr)
		file_arr.select { |file| file.include?('.zip') }.any?
	end

	def Entry.filename_contains?(file_arr, str_pattern)
		file_arr.select { |file| file.include?(str_pattern) }.any?
	end
end
