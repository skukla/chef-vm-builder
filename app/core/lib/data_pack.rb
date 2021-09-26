require_relative 'config'
require_relative 'demo_structure'
require_relative 'entry'

class DataPack
	class << self
		attr_reader :folder_list, :required_fields
	end
	@folder_list = Entry.files_from('project/data-packs')
	@required_fields = %w[name source]

	def DataPack.list
		Config.value('custom_demo/data_packs')
	end

	def DataPack.local_list
		return if list.nil?
		list.reject { |pack| pack['source'].include?('github') }
	end

	def DataPack.missing_value?
		return if list.nil?
		list.select { |pack| required_fields.include?(pack) && value.nil? }.any?
	end

	def DataPack.missing_folder?
		return if local_list.nil?
		(local_list.map { |record| record['source'] } - @folder_list).any?
	end
end
