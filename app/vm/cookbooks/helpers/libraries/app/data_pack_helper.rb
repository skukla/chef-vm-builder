require_relative 'config_helper'
require_relative 'system_helper'
require_relative 'entry_helper'
require_relative 'module_shared_helper'

class DataPackHelper
	class << self
		attr_accessor :folder_list
		attr_reader :required_fields, :files_to_remove
	end
	@folder_list = EntryHelper.files_from('magento_demo_builder/files/default')
	@files_to_remove = %w[.gitignore .DS_Store]

	def DataPackHelper.list
		list = ConfigHelper.value('custom_demo/data_packs')
		return [] if list.nil? || list.empty?

		list.map { |md| ModuleSharedHelper.prepare_data(md, 'data pack') }
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
