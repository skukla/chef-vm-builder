require_relative 'config_helper'
require_relative 'demo_structure_helper'
require_relative 'entry_helper'

class DataPackHelper
	class << self
		attr_accessor :folder_list
		attr_reader :required_fields
	end
	@folder_list = EntryHelper.files_from('magento_demo_builder/files/default')
	@required_fields = %w[name source]

	def DataPackHelper.list
		ConfigHelper.value('custom_demo/data_packs')
	end

	def DataPackHelper.local_list
		return if list.nil?
		list.reject { |pack| pack['source'].include?('github') }
	end

	def DataPackHelper.remote_list
		return if list.nil?
		list.select { |pack| pack['source'].include?('github') }
	end

	def DataPackHelper.missing_value?
		return if list.nil?
		list.select { |pack| required_fields.include?(pack) && value.nil? }.any?
	end

	def DataPackHelper.missing_folder?
		return if local_list.nil?
		(local_list.map { |record| record['source'] } - @folder_list).any?
	end

	def DataPackHelper.prepare_names(hash)
		if hash['name'].nil?
			hash['vendor'] = Chef.node[:magento_demo_builder][:data_pack][:vendor]
			hash['module_name'] = hash['source']
			hash['package_name'] = "#{hash['vendor']}/#{hash['module_name']}"
			hash['vendor_string'] = hash['vendor'].split('-').map(&:capitalize).join
			hash['module_string'] =
				hash['module_name'].split('-').map(&:capitalize).join
		end
		hash
	end

	def DataPackHelper.clean_up(dir)
		`cd #{dir} && find . -name '.DS_Store' -type f -delete`
		puts '.DS_Store files removed'

		`cd #{dir} && find . -name '.gitignore' -type f -delete`
		puts '.gitignore files removed'
	end
end
