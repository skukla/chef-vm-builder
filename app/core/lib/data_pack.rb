require_relative 'config'
require_relative 'demo_structure'
require_relative 'entry'

class DataPack
	def DataPack.list
		list = Config.value('custom_demo/data_packs')
		return [] if list.nil? || list.empty?
		list
	end

	def DataPack.data_format_error?
		return if list.empty?

		missing_source_values = list.select { |item| item['source'].nil? }
		missing_data_values = list.select { |item| item.key?('data').nil? }
		missing_data_path_values =
			list
				.flat_map { |item| item['data'] }
				.reject { |item| item.key?('data_path') }
		(
			missing_source_values.any? || missing_data_values.any? ||
				missing_data_path_values.any?
		)
	end

	def DataPack.local_list
		return [] if list.empty?
		list
			.reject do |pack|
				pack['source'].include?('github') unless pack['source'].nil?
			end
			.each { |hash| hash['data'].sort_by! { |h| h['data_path'] } }
	end

	def DataPack.source_values
		list.map { |item| item['source'] }
	end

	def DataPack.source_folders
		Entry.files_from('project/data-packs')
	end

	def DataPack.configured_data_paths
		local_list.each_with_object([]) do |item, arr|
			next if item['data'].nil?
			hash = {}
			hash['source'] = item['source']
			hash['paths'] = item['data'].map { |item| item['data_path'] }
			arr << hash
		end
	end

	def DataPack.data_path_folders
		return [] if local_list.empty? || source_folders.nil?

		DataPack
			.source_values
			.each_with_object([]) do |source, arr|
				entries = Entry.files_from("project/data-packs/#{source}/data")
				return [] if entries.to_s.empty?

				hash = {}
				hash['source'] = source
				hash['paths'] = entries
				arr << hash
			end
	end

	def DataPack.packs_missing_source_folders
		return source_values if source_folders.nil?
		return [] if local_list.empty?

		(
			local_list.map { |record| record['source'] } -
				Entry.files_from('project/data-packs')
		)
	end

	def DataPack.packs_missing_path_folders
		return [] if local_list.empty?

		configured_data_paths.each_with_object([]) do |record, arr|
			dpf_paths =
				data_path_folders
					.select { |dpf| dpf['source'] == record['source'] }
					.flat_map { |v| v['paths'] }

			return [] if dpf_paths.empty?

			hash = {}
			hash['source'] = record['source']
			hash['paths'] = (record['paths'] - dpf_paths)
			arr << hash unless hash['paths'].empty?
		end
	end

	def DataPack.packs_with_spaces_in_names
		return [] if local_list.empty? || data_path_folders.empty?

		data_path_folders.flat_map do |record|
			record['paths'].reject { |path| path.match(/^[^\s]*$/) }
		end
	end
end
