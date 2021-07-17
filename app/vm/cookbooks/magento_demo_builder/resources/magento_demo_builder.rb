# Cookbook:: magento_demo_builder
# Resource:: magento_demo_builder
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :magento_demo_builder
provides :magento_demo_builder

property :name,                             String, name_property: true
property :user,                             String, default: node[:magento_demo_builder][:init][:user]
property :group,                            String, default: node[:magento_demo_builder][:init][:user]
property :web_root,                         String, default: node[:magento_demo_builder][:nginx][:web_root]
property :db_user,                          String, default: node[:magento_demo_builder][:mysql][:db_user]
property :db_password,                      String, default: node[:magento_demo_builder][:mysql][:db_password]
property :db_name,                          String, default: node[:magento_demo_builder][:mysql][:db_name]
property :chef_files_path,                  String, default: node[:magento_demo_builder][:chef_files][:path]
property :media_type,                       String
property :data_pack_file_list,              Array, default: node[:magento_demo_builder][:data_pack][:files]
property :data_pack_data,                   Hash

action :clear_fixtures do
  data_pack_name = new_resource.data_pack_data['name']
  data_pack_source = new_resource.data_pack_data['repository_url']
  module_data = DataPackHelper.prepare_data_pack_names(data_pack_name, data_pack_source)
  module_path = "app/code/#{module_data[:vendor_string]}/#{module_data[:module_string]}"

  execute 'Clearing fixtures' do
    command "rm -rf #{new_resource.web_root}/#{module_path}/fixtures/*"
  end
end

action :create_folders do
  data_pack_name = new_resource.data_pack_data['name']
  data_pack_source = new_resource.data_pack_data['repository_url']
  module_data = DataPackHelper.prepare_data_pack_names(data_pack_name, data_pack_source)

  folders_arr = [
    'app',
    'app/code',
    "app/code/#{module_data[:vendor_string]}",
    "app/code/#{module_data[:vendor_string]}/#{module_data[:module_string]}",
    "app/code/#{module_data[:vendor_string]}/#{module_data[:module_string]}/media",
    "app/code/#{module_data[:vendor_string]}/#{module_data[:module_string]}/data",
    "app/code/#{module_data[:vendor_string]}/#{module_data[:module_string]}/etc"
  ]

  folders_arr.each do |dir|
    directory "Creating #{dir}" do
      path "#{new_resource.web_root}/#{dir}"
      owner new_resource.user
      group new_resource.group
      only_if { Dir.exist?("#{new_resource.chef_files_path}/#{data_pack_source}") }
    end
  end
end

action :create_module_files do
  data_pack_name = new_resource.data_pack_data['name']
  data_pack_source = new_resource.data_pack_data['repository_url']
  module_data = DataPackHelper.prepare_data_pack_names(data_pack_name, data_pack_source)
  module_path = "app/code/#{module_data[:vendor_string]}/#{module_data[:module_string]}"

  new_resource.data_pack_file_list.each do |file_data|
    template "Creating #{file_data[:source]}" do
      source "#{file_data[:source]}.erb"
      path "#{new_resource.web_root}/#{module_path}/#{file_data[:path]}/#{file_data[:source]}"
      owner new_resource.user
      group new_resource.group
      mode file_data[:mode]
      variables({
                  package_name: module_data[:package_name],
                  module_name: module_data[:module_name],
                  vendor_name: module_data[:vendor_name],
                  vendor_string: module_data[:vendor_string],
                  module_string: module_data[:module_string]
                })
      only_if do
        Dir.exist?("#{new_resource.chef_files_path}/#{data_pack_source}") &&
          Dir.exist?("#{new_resource.web_root}/#{module_path}")
      end
    end
  end
end

action :add_media_and_data do
  data_pack_name = new_resource.data_pack_data['name']
  data_pack_source = new_resource.data_pack_data['repository_url']
  module_data = DataPackHelper.prepare_data_pack_names(data_pack_name, data_pack_source)
  module_path = "app/code/#{module_data[:vendor_string]}/#{module_data[:module_string]}"

  next unless Dir.exist?("#{new_resource.chef_files_path}/#{data_pack_source}/#{new_resource.media_type}")

  remote_directory "Adding #{new_resource.media_type} files to the #{module_data[:module_name]} module" do
    source "#{data_pack_source}/#{new_resource.media_type}"
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

action :clean_up do
  data_pack_name = new_resource.data_pack_data['name']
  data_pack_source = new_resource.data_pack_data['repository_url']
  module_data = DataPackHelper.prepare_data_pack_names(data_pack_name, data_pack_source)

  module_path = if data_pack_source.include?('github')
                  "vendor/#{module_data[:vendor_string]}/#{module_data[:module_string]}"
                else
                  "app/code/#{module_data[:vendor_string]}/#{module_data[:module_string]}"
                end

  ruby_block "Remove unwanted hidden files from the #{module_data[:module_name]} data pack" do
    block do
      ModuleListHelper.clean_up_module_data("#{new_resource.web_root}/#{module_path}")
    end
    only_if { ::Dir.exist?("#{new_resource.web_root}/#{module_path}") }
  end
end

action :install do
  data_pack_name = new_resource.data_pack_data['name']
  data_pack_source = new_resource.data_pack_data['repository_url']
  module_data = DataPackHelper.prepare_data_pack_names(data_pack_name, data_pack_source)

  magento_cli "Installing the #{module_data[:module_string]} data pack" do
    action :run
    command_list "gxd:datainstall #{module_data[:vendor_string]}_#{module_data[:module_string]} -r"
  end
end
