require_relative 'config_helper'
require_relative 'demo_structure_helper'
require_relative 'entry_helper'
require_relative 'system_helper'

require 'json'

class DataPackHelper
	class << self
		attr_accessor :folder_list
		attr_reader :required_fields, :files_to_remove
	end
	@folder_list = EntryHelper.files_from('magento_demo_builder/files/default')
	@required_fields = %w[name source]
	@files_to_remove = %w[.gitignore .DS_Store]

	def DataPackHelper.list
		ConfigHelper
			.value('custom_demo/data_packs')
			.map { |md| DataPackHelper.prepare_data(md) }
	end

	def DataPackHelper.local_list
		return if list.nil?
		result = list.reject { |pack| pack['source'].include?('github') }
		result.empty? ? nil : result
	end

	def DataPackHelper.remote_list
		return if list.nil?
		result = list.select { |pack| pack['source'].include?('github') }
		result.empty? ? nil : result
	end

	def DataPackHelper.get_load_dirs(data_pack)
		return nil if data_pack['data'].nil? || data_pack['data'].empty?

		data_pack['data'].each_with_object([]) do |item, arr|
			next if item['path'].nil?

			arr << item['path']
		end
	end

	def DataPackHelper.set_version(version_str)
		return 'dev-master' if version_str.nil?
		version_str
	end

	def DataPackHelper.strip_version(version_str)
		version_str.sub('dev-', '')
	end

	def DataPackHelper.get_remote_package_name(source, version_str)
		return nil if source.nil? || !source.include?('github')

		tok = ConfigHelper.value('application/authentication/composer/github_token')
		github_raw_url = "https://#{tok}@raw.githubusercontent.com"
		segment = StringReplaceHelper.parse_source_url(source)
		url_str =
			[
				github_raw_url,
				segment[:org],
				segment[:module],
				version_str,
				'composer.json',
			].join('/')

		JSON.parse(SystemHelper.cmd("curl -s #{url_str} | jq .name"))
	end

	def DataPackHelper.prepare_data(hash)
		unless hash['source'].include?('github')
			hash['vendor_string'] =
				Chef.node[:magento_demo_builder][:data_pack][:vendor]
			hash['package_name'] = "#{hash['vendor_string']}/#{hash['source']}"
			hash['module_string'] = hash['source']
		end

		if hash['source'].include?('github')
			hash['version'] = DataPackHelper.set_version(hash['version'])
			stripped_version = DataPackHelper.strip_version(hash['version'])
			hash['package_name'] =
				DataPackHelper.get_remote_package_name(hash['source'], stripped_version)
			hash['vendor_string'] = hash['package_name'].split('/')[0]
			hash['module_string'] = hash['package_name'].split('/')[1]
		end

		hash
	end

	def DataPackHelper.clean_up(path)
		@files_to_remove.each do |file_type|
			SystemHelper.cmd("find #{path} -name '#{file_type}' -type f -delete")
			puts "#{file_type} files removed"
		end
	end
end
