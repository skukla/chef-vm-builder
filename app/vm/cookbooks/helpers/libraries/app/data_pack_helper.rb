# Cookbook:: helpers
# Library:: app/data_pack_helper
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

class DataPackHelper
	class << self
		attr_accessor :folder_list
		attr_reader :required_fields, :files_to_remove
	end
	@files_to_remove = %w[.gitignore .DS_Store]

	def DataPackHelper.list
		list = ConfigHelper.value('custom_demo/data_packs')
		return [] if list.nil? || list.empty?

		list.map { |md| ModuleSharedHelper.prepare_data(md, 'dp') }
	end

	def DataPackHelper.local_list
		return [] if list.empty?
		result = list.reject { |pack| pack['source'].include?('github') }
		result.empty? ? [] : result
	end

	def DataPackHelper.remote_list
		return [] if list.empty?
		result = list.select { |pack| pack['source'].include?('github') }
		result.empty? ? [] : result
	end

	def DataPackHelper.get_load_dirs(data_pack)
		return [] if data_pack['data'].nil? || data_pack['data'].empty?

		data_pack['data'].each_with_object([]) do |item, arr|
			next if item['path'].nil?

			arr << item['path']
		end
	end

	def DataPackHelper.clean_up(path)
		@files_to_remove.each do |file_type|
			SystemHelper.cmd("find #{path} -name '#{file_type}' -type f -delete")
			puts "#{file_type} files removed"
		end
	end
end
