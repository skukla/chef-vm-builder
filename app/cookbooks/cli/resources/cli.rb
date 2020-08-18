#
# Cookbook:: cli
# Resource:: cli 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :cli
provides :cli

property :name,                     String,    name_property: true
property :user,                     String,    default: node[:cli][:init][:user]
property :group,                    String,    default: node[:cli][:init][:user]
property :webserver_type,           String,    default: node[:cli][:init][:webserver_type]
property :web_root,                 String,    default: node[:cli][:init][:web_root]
property :php_version,              String,    default: node[:cli][:php][:version]
property :magento_version,          String,    default: node[:cli][:magento][:version]
property :db_host,                  String,    default: node[:cli][:mysql][:db_host]
property :db_user,                  String,    default: node[:cli][:mysql][:db_user]
property :db_password,              String,    default: node[:cli][:mysql][:db_password]
property :db_name,                  String,    default: node[:cli][:mysql][:db_name]
property :cli_directories,          Array,     default: node[:cli][:directories]
property :cli_files,                Array,     default: node[:cli][:files]
property :consumer_list,            Array,     default: node[:cli][:magento][:consumer_list]

action :create_directories do
    directory "VM cli path check" do
        path "/home/#{new_resource.user}/cli"
        recursive true
        action :delete
    end

    new_resource.cli_directories.each do |directory_data|
        directory "Creating /home/#{new_resource.user}/#{directory_data[:path]}" do
            path "/home/#{new_resource.user}/#{directory_data[:path]}"
            owner "#{new_resource.user}"
            group "#{new_resource.group}"
            mode "#{directory_data[:mode]}"
            not_if { ::Dir.exist?("#{directory_data[:path]}") }
        end
    end
end

action :install do
    template "VM CLI" do
        source "commands.sh.erb"
        path "/home/#{new_resource.user}/cli/commands.sh"
        mode "755"
        owner new_resource.user
        group new_resource.group
        variables ({
            user: new_resource.user,
            webserver_type: new_resource.webserver_type,
            web_root: new_resource.web_root,
            php_version: new_resource.php_version,
            magento_version: new_resource.magento_version,
            db_host: new_resource.db_host,
            db_user: new_resource.db_user,
            db_password: new_resource.db_password,
            db_name: new_resource.db_name,
            consumer_list: new_resource.consumer_list
        })
        only_if { ::Dir.exist?("/home/#{new_resource.user}/cli") }
    end

    new_resource.cli_files.each do |cli_file_data|  
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