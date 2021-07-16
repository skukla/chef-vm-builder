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
			name: 'classes',
			src: 'app/lib',
			dest: 'app/cookbooks/helpers/libraries/app',
			file: %w[config.rb demo_structure.rb],
		},
		{
			name: 'data packs',
			src: 'project/data_packs',
			dest: 'app/cookbooks/magento_demo_builder/files/default',
		},
		{
			name: 'backups',
			src: 'project/backup',
			dest: 'app/cookbooks/magento_restore/files/default',
			exts: %w[.zip .tgz .sql],
		},
		{
			name: 'patches',
			src: 'project/patches',
			dest: 'app/cookbooks/magento_patches/files/default',
			exts: %w[.patch],
		},
		{
			name: 'keys',
			src: 'project/keys',
			dest: 'app/cookbooks/magento/files/default',
			exts: %w[.pem],
		},
	]

	def EntryHandler.copy_entries
		@entries.each do |type|
			src_files = Entry.files_from(type[:src])
			dest_files = Entry.files_from(type[:dest])

			return if src_files.empty?

			unless type[:exts].nil?
				src_files =
					src_files.select { |file| type[:exts].include?(File.extname(file)) }
			end

			unless type[:file].nil?
				src_files =
					src_files.select { |file| type[:file].include?(File.basename(file)) }
			end

			unless dest_files.empty?
				dest_files.each do |file|
					FileUtils.rm_r(File.join(@app_root, type[:dest], file))
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
			.each { |path| `find #{path} -name '.DS_Store' -type f -delete` }
	end

	def EntryHandler.create_environment_file
		environment_file_content = {
			name: 'vm',
			description: 'Configuration file for the Kukla Demo VM',
			default_attributes: {},
			override_attributes: Config.json,
			chef_type: 'environment',
		}
		File.open(File.join(@app_root, 'app/environments/vm.json'), 'w+') do |file|
			file.puts(environment_file_content.to_json)
		end
	end
end
