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
			dest: 'app/vm/cookbooks/helpers/libraries',
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

	def EntryHandler.prefer_zip(entry_list)
		zip_file_arr = entry_list.select { |file| file.include?('.zip') }
		return zip_file_arr unless zip_file_arr.empty?
		entry_list
	end

	def EntryHandler.copy_entries
		@entries.each do |type|
			src_files = Entry.files_from(type[:src])
			dest_files = Entry.files_from(type[:dest])

			next if src_files.empty? && dest_files.empty?

			unless type[:exts].nil?
				src_files = filter_entries(src_files, type[:exts], 'ext')
				src_files = prefer_zip(src_files)
			end

			unless type[:file].nil?
				src_files = filter_entries(src_files, type[:file], 'file')
				dest_files = filter_entries(dest_files, type[:file], 'file')
			end

			unless dest_files.empty?
				dest_files.each do |file|
					path = File.join(@app_root, type[:dest], file)
					FileUtils.rm_r(path) if Dir.exist?(path)
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
		entries
			.map { |entry| "#{File.join(Config.app_root, entry[:dest])}" }
			.each { |path| SystemHandler.remove_ds_store_files(path) }
	end

	def EntryHandler.remove_machine_dirs
		machines_slug = File.join('app', 'vm', '.vagrant', 'machines')
		vm_name = Config.vm_name
		hypervisor = Hypervisor.value

		vm_dir = File.join(@app_root, machines_slug, vm_name)
		provider_dir = File.join(@app_root, machines_slug, vm_name, hypervisor)

		return unless Dir.exist?(vm_dir)

		provider_slug = Entry.last_slug(provider_dir)

		if Dir.exist?(provider_dir) &&
				(
					Hypervisor.list.include?(provider_slug) ||
						hypervisor.include?('vmware')
				)
			FileUtils.rm_rf(provider_dir)
		end

		if Entry.last_slug(vm_dir) == vm_name && Dir.empty?(vm_dir)
			FileUtils.rm_rf(vm_dir)
		end
	end
end
