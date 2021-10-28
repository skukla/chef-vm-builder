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

	def DataPack.missing_data_path?
		return if list.empty?
		list.reject { |item| item.key?('data') }.any?
	end

	def DataPack.data_dir_list
		return [] if list.empty?
		list
			.select { |item| !item['data'].nil? && item['data'].is_a?(Array) }
			.flat_map { |rec| rec['data'] }
	end

	def DataPack.missing_data_code?
		return true if list.empty? || data_dir_list.nil?

		data_dir_list
			.each_with_object([]) do |item, arr|
				arr << item if (item['site_code'].nil? && item['store_view_code'].nil?)
			end
			.any?
	end

	def DataPack.data_format_error?
		return if list.empty?
		(missing_source? || missing_data_path?)
	end

	def DataPack.missing_folder?
		return if local_list.nil? || local_list.empty?
		(local_list.map { |record| record['source'] } - @folder_list).any?
	end

	def DataPack.bad_folder_names
		return if @folder_list.empty?

		@folder_list
			.map { |path| Entry.path(File.join('project/data-packs', path)) }
			.select { |path| File.directory?(path) }
			.reject { |path| path.to_s.match(/^[^\s]*$/) }
			.map { |path| File.basename(path.to_s) }
	end
end
