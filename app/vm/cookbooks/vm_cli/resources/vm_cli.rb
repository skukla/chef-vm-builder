# Cookbook:: vm_cli
# Resource:: vm_cli
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :vm_cli
provides :vm_cli

property :name, String, name_property: true
property :vm_provider, String, default: node[:vm_cli][:init][:provider]
property :user, String, default: node[:vm_cli][:init][:user]
property :group, String, default: node[:vm_cli][:init][:user]
property :web_root, String, default: node[:vm_cli][:nginx][:web_root]
property :php_version, String, default: node[:vm_cli][:php][:version]
property :search_engine_setting_config_path,
         String,
         default: node[:vm_cli][:search_engine][:setting_config_path]
property :search_engine_host_config_path,
         String,
         default: node[:vm_cli][:search_engine][:host_config_path]
property :search_engine_port_config_path,
         String,
         default: node[:vm_cli][:search_engine][:port_config_path]
property :search_engine_prefix_config_path,
         String,
         default: node[:vm_cli][:search_engine][:prefix_config_path]
property :search_engine_setting,
         String,
         default: node[:vm_cli][:search_engine][:setting]
property :search_engine_host,
         String,
         default: node[:vm_cli][:search_engine][:host]
property :search_engine_port,
         String,
         default: node[:vm_cli][:search_engine][:port]
property :search_engine_prefix,
         String,
         default: node[:vm_cli][:search_engine][:prefix]
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
property :vm_cli_directories, Array, default: node[:vm_cli][:directories]
property :vm_cli_files, Array, default: node[:vm_cli][:files]
property :command_list, [String, Array]

action :create_directories do
  directory 'VM cli path check' do
    path "/home/#{new_resource.user}/cli"
    recursive true
    action :delete
  end

  new_resource.vm_cli_directories.each do |directory_data|
    directory "Creating /home/#{new_resource.user}/#{directory_data[:path]}" do
      path "/home/#{new_resource.user}/#{directory_data[:path]}"
      owner new_resource.user.to_s
      group new_resource.group.to_s
      mode (directory_data[:mode]).to_s
      not_if { ::Dir.exist?((directory_data[:path]).to_s) }
    end
  end
end

action :install do
  protocol = 'http'
  template 'VM CLI' do
    source 'commands.sh.erb'
    path "/home/#{new_resource.user}/cli/commands.sh"
    mode '755'
    owner new_resource.user
    group new_resource.group
    variables(
      {
        provider: new_resource.vm_provider,
        user: new_resource.user,
        urls: DemoStructureHelper.vm_urls,
        base_url: DemoStructureHelper.base_url,
        web_root: new_resource.web_root,
        php_version: new_resource.php_version,
        magento_version: new_resource.magento_version,
        db_host: new_resource.db_host,
        db_user: new_resource.db_user,
        db_password: new_resource.db_password,
        db_name: new_resource.db_name,
        search_engine_setting_config_path:
          new_resource.search_engine_setting_config_path,
        search_engine_host_config_path:
          new_resource.search_engine_host_config_path,
        search_engine_port_config_path:
          new_resource.search_engine_port_config_path,
        search_engine_prefix_config_path:
          new_resource.search_engine_prefix_config_path,
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
    only_if { ::Dir.exist?("/home/#{new_resource.user}/cli") }
  end

  new_resource.vm_cli_files.each do |cli_file_data|
    cookbook_file "Copying file : /home/#{new_resource.user}/#{cli_file_data[:source]}" do
      source cli_file_data[:source]
      path "/home/#{new_resource.user}/#{cli_file_data[:path]}/#{cli_file_data[:source]}"
      owner new_resource.user
      group new_resource.group
      mode cli_file_data[:mode]
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
