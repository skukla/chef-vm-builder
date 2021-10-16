require_relative '../lib/config'
require_relative '../lib/data_pack'
require_relative '../lib/custom_module'
require_relative '../lib/error_message'

require 'fileutils'
require 'json'

class EntryHandler
	class << self
		attr_reader :entries
	end
	@app_root = Config.app_root
	@entries = [
		{
			src: '',
			dest: 'app/vm/cookbooks/helpers/libraries/app',
			file: %w[config.json],
		},
		{
			src: 'project/data-packs',
			dest: 'app/vm/cookbooks/magento_demo_builder/files/default',
		},
		{
			src: 'project/backup',
			dest: 'app/vm/cookbooks/magento_restore/files/default',
			exts: %w[.zip .tgz .sql],
		},
		{
			src: 'project/patches',
			dest: 'app/vm/cookbooks/magento_patches/files/default',
			exts: %w[.patch],
		},
		{
			src: 'project/keys',
			dest: 'app/vm/cookbooks/magento/files/default',
			exts: %w[.pem],
		},
	]

	def EntryHandler.filter_entries(entry_list, filter_arr, filter_type)
		case filter_type
		when 'ext'
			entry_list.select { |entry| filter_arr.include?(File.extname(entry)) }
		when 'file'
			entry_list.select { |entry| filter_arr.include?(File.basename(entry)) }
		end
	end

	def EntryHandler.copy_entries
		@entries.each do |type|
			src_files = Entry.files_from(type[:src])
			dest_files = Entry.files_from(type[:dest])

			next if src_files.empty? && dest_files.empty?

			unless type[:exts].nil?
				src_files = filter_entries(src_files, type[:exts], 'ext')
			end

			unless type[:file].nil?
				src_files = filter_entries(src_files, type[:file], 'file')
				dest_files = filter_entries(dest_files, type[:file], 'file')
			end

			unless dest_files.empty?
				dest_files.each do |file|
					path = File.join(@app_root, type[:dest], file)
					FileUtils.rm_r(path) if File.directory?(path)
					FileUtils.rm(path) if File.file?(path)
				end
			end

			src_files.each do |file|
				FileUtils.cp_r(
					File.join(@app_root, type[:src], file),
					File.join(@app_root, type[:dest]),
				)
			end
		end
	end

	def EntryHandler.clean_up_hidden_files
		EntryHandler
			.entries
			.map { |entry| "#{File.join(Config.app_root, entry[:dest])}" }
			.each { |path| SystemHandler.remove_ds_store_files(path) }
	end

	def EntryHandler.create_environment_file
		environment_file_content = {
			name: 'vm',
			description: 'Configuration file for the Kukla Demo VM',
			default_attributes: {},
			override_attributes: Config.json,
			chef_type: 'environment',
		}
		File.open(
			File.join(@app_root, 'app/vm/environments/vm.json'),
			'w+',
		) { |file| file.puts(environment_file_content.to_json) }
	end
end

EntryHandler.copy_entries
