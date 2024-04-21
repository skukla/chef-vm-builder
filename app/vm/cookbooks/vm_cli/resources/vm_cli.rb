# Cookbook:: vm_cli
# Resource:: vm_cli
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :vm_cli
provides :vm_cli

property :name, String, name_property: true
property :vm_cli_directory, Hash, default: node[:vm_cli][:directory]
property :vm_cli_files, Array, default: node[:vm_cli][:files]
property :vm_provider, String, default: node[:vm_cli][:init][:provider]
property :user, String, default: node[:vm_cli][:init][:user]
property :group, String, default: node[:vm_cli][:init][:user]
property :web_root, String, default: node[:vm_cli][:nginx][:web_root]
property :php_version, String, default: node[:vm_cli][:php][:version]
property :search_engine_setting,
         Hash,
         default: node[:vm_cli][:search_engine][:setting]
property :search_engine_host,
         Hash,
         default: node[:vm_cli][:search_engine][:host]
property :search_engine_port,
         Hash,
         default: node[:vm_cli][:search_engine][:port]
property :search_engine_prefix,
         Hash,
         default: node[:vm_cli][:search_engine][:prefix]
property :es_module_list,
         Array,
         default: node[:magento][:search_engine][:elasticsearch][:module_list]
property :ls_module_list,
         Array,
         default: node[:magento][:search_engine][:live_search][:module_list]
property :magento_version, String, default: node[:vm_cli][:magento][:version]
property :use_secure_frontend,
         [Integer, TrueClass, FalseClass, String],
         default: node[:vm_cli][:magento][:use_secure_frontend]
property :db_host, String, default: node[:vm_cli][:mysql][:db_host]
property :db_user, String, default: node[:vm_cli][:mysql][:db_user]
property :db_password, String, default: node[:vm_cli][:mysql][:db_password]
property :db_name, String, default: node[:vm_cli][:mysql][:db_name]
property :build_dir,
         String,
         default: node[:vm_cli][:magento_demo_builder][:build_dir]
property :backup_holding_area,
         String,
         default: node[:vm_cli][:magento_restore][:backup_holding_area]
property :local_data_pack_list,
         Array,
         default: node[:vm_cli][:magento_demo_builder][:local_data_pack_list]
property :config_json_dir, String, default: node[:vm_cli][:config_json_dir]
property :backup_dir, String, default: node[:vm_cli][:backup_dir]
property :command_list, [String, Array]

action :create_directory do
  cli_dir = "/home/#{new_resource.user}/#{new_resource.vm_cli_directory[:path]}"

  directory 'VM cli path check' do
    path cli_dir
    recursive true
    action :delete
  end

  directory 'Creating VM CLI directory' do
    path cli_dir
    owner new_resource.user
    group new_resource.group
    mode (new_resource.vm_cli_directory[:mode])
    not_if { ::Dir.exist?(cli_dir) }
  end
end

action :install_commands do
  cli_dir = "/home/#{new_resource.user}/#{new_resource.vm_cli_directory[:path]}"

  template 'VM CLI' do
    source 'commands.sh.erb'
    path "#{cli_dir}/commands.sh"
    mode '755'
    owner new_resource.user
    group new_resource.group
    variables(
      {
        provider: new_resource.vm_provider,
        user: new_resource.user,
        urls: DemoStructureHelper.vm_urls,
        base_url: DemoStructureHelper.base_url,
        cli_directory: cli_dir,
        cli_files: new_resource.vm_cli_files,
        web_root: new_resource.web_root,
        php_version: new_resource.php_version,
        magento_version: new_resource.magento_version,
        db_host: new_resource.db_host,
        db_user: new_resource.db_user,
        db_password: new_resource.db_password,
        db_name: new_resource.db_name,
        es_modules: new_resource.es_module_list,
        ls_modules: new_resource.ls_module_list,
        search_engine_setting: new_resource.search_engine_setting,
        search_engine_host: new_resource.search_engine_host,
        search_engine_port: new_resource.search_engine_port,
        search_engine_prefix: new_resource.search_engine_prefix,
        local_data_pack_list: new_resource.local_data_pack_list,
        build_dir: new_resource.build_dir,
        config_json_dir: new_resource.config_json_dir,
        backup_dir: new_resource.backup_dir,
        backup_holding_area: new_resource.backup_holding_area,
        consumer_list: MagentoHelper.consumer_list,
      },
    )
    only_if { ::Dir.exist?(cli_dir) }
  end
end

action :install_files do
  cli_dir = "/home/#{new_resource.user}/#{new_resource.vm_cli_directory[:path]}"

  new_resource.vm_cli_files.each do |cli_file|
    cookbook_file "Copying the #{cli_file[:source]} file" do
      source cli_file[:source]
      path "#{cli_dir}/#{cli_file[:source]}"
      owner new_resource.user
      group new_resource.group
      mode cli_file[:mode]
      action :create
    end
  end
end

action :run do
  command_list = []
  if new_resource.command_list.is_a?(String)
    command_list << new_resource.command_list
  else
    command_list = new_resource.command_list
  end

  command_list.each do |command|
    bash "Running the #{command} VM CLI command" do
      code lazy { <<~CONTENT }
          source /home/#{new_resource.user}/cli/commands.sh
          #{command}
        CONTENT
      cwd new_resource.web_root
    end
  end
end
