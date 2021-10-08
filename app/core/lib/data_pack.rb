require_relative 'config'
require_relative 'demo_structure'
require_relative 'entry'

class DataPack
	class << self
		attr_reader :folder_list, :required_fields
	end
	@folder_list = Entry.files_from('project/data-packs')
	@required_fields = %w[source load]

	def DataPack.list
		list = Config.value('custom_demo/data_packs')
		return [] if list.nil? || list.empty?
		list
	end

	def DataPack.local_list
		return [] if list.empty?
		list.reject { |pack| pack['source'].include?('github') }
	end

	def DataPack.missing_source?
		return nil if list.empty?
		list.select { |item| item['source'].to_s.empty? }.any?
	end

	def DataPack.data_dir_list
		return [] if list.empty?
		list
			.select { |item| !item['data'].nil? && item['data'].is_a?(Array) }
			.flat_map { |rec| rec['data'] }
	end

	def DataPack.data_format_error?
		return nil if list.empty?
		list.select do |item|
			!item['data'].to_s.empty? && !item['data'].is_a?(Array)
		end.any?
	end

	def DataPack.missing_data_path?
		data_dir_list = DataPack.data_dir_list
		return true if list.empty? || data_dir_list.nil?

		DataPack
			.data_dir_list
			.flat_map { |item| item.keys }
			.each_with_object([]) { |key, arr| arr << key if key == 'path' }
			.empty?
	end

	def DataPack.missing_data_code?
		data_dir_list = DataPack.data_dir_list
		return true if list.empty? || data_dir_list.nil?

		data_dir_list
			.flat_map { |item| item.keys }
			.each_with_object([]) do |key, arr|
				if key.include?('code') &&
						!%w[site_code store_code store_view_code].include?(key)
					arr << key
				end
			end
			.any?
	end

	def DataPack.missing_folder?
		return true if local_list.nil? || local_list.empty?
		(local_list.map { |record| record['source'] } - @folder_list).any?
	end
end
