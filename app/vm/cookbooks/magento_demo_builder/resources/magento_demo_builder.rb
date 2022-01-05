# Cookbook:: magento_demo_builder
# Resource:: magento_demo_builder
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :magento_demo_builder
provides :magento_demo_builder

property :name, String, name_property: true
property :user, String, default: node[:magento_demo_builder][:init][:user]
property :group, String, default: node[:magento_demo_builder][:init][:user]
property :web_root,
         String,
         default: node[:magento_demo_builder][:nginx][:web_root]
property :db_user,
         String,
         default: node[:magento_demo_builder][:mysql][:db_user]
property :db_password,
         String,
         default: node[:magento_demo_builder][:mysql][:db_password]
property :db_name,
         String,
         default: node[:magento_demo_builder][:mysql][:db_name]
property :chef_files_path,
         String,
         default: node[:magento_demo_builder][:chef_files][:path]
property :media_type, String
property :data_pack_file_list,
         Array,
         default: node[:magento_demo_builder][:data_pack][:files]
property :data_pack_data, Hash

action :clear_data_and_media do
	data_pack = new_resource.data_pack_data
	module_path =
		"app/code/#{data_pack['vendor_string']}/#{data_pack['module_string']}"

	if Dir.exist?("#{module_path}/#{new_resource.media_type}") &&
			!Dir.empty?("#{module_path}/#{new_resource.media_type}")
		execute "Clearing #{new_resource.media_type} from #{data_pack['vendor_string']}/#{data_pack['module_string']}" do
			command "rm -rf #{new_resource.web_root}/#{module_path}/#{new_resource.media_type}/*"
		end
	end
end

action :create_folders do
	data_pack = new_resource.data_pack_data

	folders_arr = [
		'app',
		'app/code',
		"app/code/#{data_pack['vendor_name']}",
		"app/code/#{data_pack['vendor_name']}/#{data_pack['module_name']}",
		"app/code/#{data_pack['vendor_name']}/#{data_pack['module_name']}/etc",
		"app/code/#{data_pack['vendor_name']}/#{data_pack['module_name']}/data",
		"app/code/#{data_pack['vendor_name']}/#{data_pack['module_name']}/media",
	]

	folders_arr.each do |dir|
		directory "Creating #{dir}" do
			path "#{new_resource.web_root}/#{dir}"
			owner new_resource.user
			group new_resource.group
			only_if do
				Dir.exist?("#{new_resource.chef_files_path}/#{data_pack['source']}")
			end
		end
	end
end

action :create_module_files do
	data_pack = new_resource.data_pack_data

	module_path =
		"app/code/#{data_pack['vendor_name']}/#{data_pack['module_name']}"

	new_resource.data_pack_file_list.each do |file_data|
		template "Creating #{file_data[:source]}" do
			source "#{file_data[:source]}.erb"
			path "#{new_resource.web_root}/#{module_path}/#{file_data[:path]}/#{file_data[:source]}"
			owner new_resource.user
			group new_resource.group
			mode file_data[:mode]
			variables(
				{
					package_name: data_pack['package_name'],
					vendor_string: data_pack['vendor_string'],
					module_string: data_pack['module_string'],
				},
			)
			only_if do
				Dir.exist?("#{new_resource.chef_files_path}/#{data_pack['source']}") &&
					Dir.exist?("#{new_resource.web_root}/#{module_path}")
			end
		end
	end
end

action :add_media_and_data do
	data_pack = new_resource.data_pack_data

	module_path =
		"app/code/#{data_pack['vendor_name']}/#{data_pack['module_name']}"

	if Dir.exist?(
			"#{new_resource.chef_files_path}/#{data_pack['source']}/#{new_resource.media_type}",
	   )
		remote_directory "Adding #{new_resource.media_type} files to the #{data_pack['module_name']} module" do
			source "#{data_pack['source']}/#{new_resource.media_type}"
			path "#{new_resource.web_root}/#{module_path}/#{new_resource.media_type}"
			owner new_resource.user
			group new_resource.group
			files_owner new_resource.user
			files_group new_resource.group
			action :create
			recursive false
			overwrite true
		end
	end
end

action :clean_up do
	data_pack = new_resource.data_pack_data
	module_prefix = 'app/code'
	github_url = StringReplaceHelper.parse_source_url(data_pack['source'])
	module_prefix = 'vendor' if github_url
	module_path =
		"#{module_prefix}/#{data_pack['vendor_name']}/#{data_pack['module_name']}"

	ruby_block "Remove unwanted hidden files from the #{data_pack['module_name']} data pack" do
		block { DataPackHelper.clean_up("#{new_resource.web_root}/#{module_path}") }
		only_if { ::Dir.exist?("#{new_resource.web_root}/#{module_path}") }
	end
end

action :install do
	data_pack = new_resource.data_pack_data
	load_dirs = DataPackHelper.get_load_dirs(data_pack)
	module_prefix = 'app/code'
	github_url = StringReplaceHelper.parse_source_url(data_pack['source'])
	module_prefix = 'vendor' if github_url
	data_pack_str =
		"#{module_prefix}/#{data_pack['vendor_name']}/#{data_pack['module_name']}"

	if load_dirs.empty?
		magento_cli "Installing the #{data_pack['module_string']} data pack" do
			action :run
			command_list "gxd:datainstall #{data_pack_str} -r"
		end
	end

	unless load_dirs.empty?
		load_dirs.each do |dir|
			magento_cli "Installing the #{data_pack['module_name']} data pack" do
				action :run
				command_list "gxd:datainstall --load=#{dir} --host=subdomain #{data_pack_str} -r"
			end
		end
	end
end
