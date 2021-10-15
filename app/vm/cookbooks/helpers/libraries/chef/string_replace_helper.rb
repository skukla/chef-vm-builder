# Cookbook:: helpers
# Library:: chef/string_replace_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

module StringReplaceHelper
	def StringReplaceHelper.set_php_sendmail_path(
		php_type,
		php_version,
		sendmail_path
	)
		line_to_insert =
			if sendmail_path.empty?
				';sendmail_path ='
			else
				"sendmail_path = #{sendmail_path}"
			end

		file =
			Chef::Util::FileEdit.new("/etc/php/#{php_version}/#{php_type}/php.ini")
		file.insert_line_if_no_match(/^sendmail_path =/, sendmail_path.to_s)
		file.search_file_replace_line(/^sendmail_path =/, line_to_insert)
		file.write_file
	end

	def StringReplaceHelper.remove_modules(selected_modules, composer_json)
		modules_to_remove = []

		return if selected_modules.nil? || selected_modules.empty?

		if selected_modules.is_a?(Array)
			modules_to_remove =
				selected_modules.each_with_object([]) { |item, arr| arr << item }
		end

		modules_to_remove << item if selected_modules.is_a?(String)

		replace_string_format = '%4s%s:'
		module_format = '%8s"%s": "*"'
		replace_block_format = "%s{\n%s\n%4s},\n"

		modules_list =
			modules_to_remove.each_with_object([]) do |item, arr|
				arr << format(module_format, "\s", item.to_s)
			end

		file = Chef::Util::FileEdit.new(composer_json.to_s)
		file.insert_line_after_match(
			'minimum-stability',
			format(
				replace_block_format,
				format(replace_string_format, "\s", '"replace"'),
				modules_list.join(",\n"),
				"\s",
			),
		)
		file.write_file
	end

	def StringReplaceHelper.set_project_stability(stability_level, composer_json)
		replace_string_format = "%4s\"minimum-stability\": \"#{stability_level}\","
		file = Chef::Util::FileEdit.new(composer_json.to_s)
		file.search_file_replace_line(
			'minimum-stability',
			format(replace_string_format, "\s"),
		)
		file.write_file
	end

	def StringReplaceHelper.to_camel(string)
		if string.include?('-')
			return string.split('-').map { |e| e.capitalize }.join
		end
		string
	end

	def StringReplaceHelper.parse_source_url(url)
		return nil unless url.include?('github')

		url = url.sub('https://github.com/', '') if url.include?('https://')
		url = url.sub('git@github.com:', '') if url.include?('git@github.com')
		url_segment = url.split(':')[1].split('/') if url.include?('git@github.com')
		url_segment = url.split('/') unless url.include?('git@github.com')
		{ org: url_segment[0], module: url_segment[1].sub('.git', '') }
	end
end
