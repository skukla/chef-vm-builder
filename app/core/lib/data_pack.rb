require_relative 'config'
require_relative 'demo_structure'
require_relative 'entry'

class DataPack
	class << self
		attr_reader :folder_list, :required_fields
	end
	@folder_list = Entry.files_from('project/data_packs')
	@required_fields = %w[name source]

	def DataPack.list
		Config.setting('custom_demo/data_packs')
	end

	def DataPack.local_list
		list
			.reject { |pack| pack['source'].include?('github') }
			.map { |record| record['source'] }
	end

	def DataPack.missing_folder?
		(local_list - @folder_list).any?
	end
end
