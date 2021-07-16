require_relative 'config'
require_relative 'demo_structure'
require_relative 'entry'

class DataPack
	class << self
		attr_reader :folder_list, :required_fields
	end
	@folder_list = Entry.files_from('project/data_packs')
	@required_fields = %w[name repository_url]

	def DataPack.list
		Config.setting('custom_demo/data_packs')
	end

	def DataPack.local_list
		list.reject do |key, value|
			key == 'repository_url' && value.include?('github')
		end
	end

	def DataPack.missing_value?
		list.select do |_, pack|
			pack.any? { |key, value| required_fields.include?(key) && value.empty? }
		end.any?
	end

	def DataPack.missing_folder?
		configured_local_list = local_list.map { |_, pack| pack['repository_url'] }

		(configured_local_list - @folder_list).any?
	end
end
