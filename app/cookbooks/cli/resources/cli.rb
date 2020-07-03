#
# Cookbook:: cli
# Resource:: cli 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :cli
provides :cli

property :name,                     String, name_property: true
property :user,                     String, default: node[:cli][:user]
property :group,                    String, default: node[:cli][:user]
property :web_root,                 String, default: node[:cli][:nginx][:web_root]
property :php_version,              String, default: node[:cli][:php][:version]
property :magento_version,          String, default: node[:cli][:magento][:version]
property :db_host,                  String, default: node[:cli][:database][:host]
property :db_user,                  String, default: node[:cli][:database][:user]
property :db_password,              String, default: node[:cli][:database][:password]
property :db_name,                  String, default: node[:cli][:database][:name]
property :private_keys_list,        Array, default: node[:ssh][:private_keys][:files]
property :configuration,            Hash

action :create_directories do
    directory 'VM cli path check' do
        path "/home/#{new_resource.user}/cli"
        recursive true
        action :delete
    end

    new_resource.configuration[:cli_directories].each do |directory_data|
        directory "Creating /home/#{new_resource.user}/#{directory_data[:path]}" do
            path "/home/#{new_resource.user}/#{directory_data[:path]}"
            owner "#{new_resource.user}"
            group "#{new_resource.group}"
            mode "#{directory_data[:mode]}"
            not_if { ::File.directory?("#{directory_data[:path]}") }
        end
    end
end

action :install do
    template "VM CLI" do
        source "commands.sh.erb"
        path "/home/#{new_resource.user}/cli/commands.sh"
        mode "755"
        owner "#{new_resource.user}"
        group "#{new_resource.group}"
        variables ({
            user: "#{new_resource.user}",
            web_root: "#{new_resource.web_root}",
            php_version: "#{new_resource.php_version}",
            magento_version: "#{new_resource.magento_version}",
            db_host: "#{new_resource.db_host}",
            db_user: "#{new_resource.db_user}",
            db_password: "#{new_resource.db_password}",
            db_name: "#{new_resource.db_name}",
            private_keys_list: new_resource.private_keys_list
        })
        only_if { ::File.directory?("/home/#{new_resource.user}/cli") }
    end

    new_resource.configuration[:cli_files].each do |cli_file_data|  
        cookbook_file "Copying file : /home/#{new_resource.user}/#{cli_file_data[:source]}" do
            source "#{cli_file_data[:source]}"
            path "/home/#{new_resource.user}/#{cli_file_data[:path]}/#{cli_file_data[:source]}"
            owner "#{new_resource.user}"
            group "#{new_resource.group}"
            mode "#{cli_file_data[:mode]}"
            action :create
        end
    end
end