#
# Cookbook:: cli
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
php_version = node[:cli][:php_version]
magento_version = node[:application][:installation][:options][:version]
private_key_files = node[:ssh][:private_key_files]
cli_directories = node[:cli][:directories]
cli_files = node[:cli][:files]
db_host = node[:cli][:database_host]
db_user = node[:cli][:database_user]
db_password = node[:cli][:database_password]
db_name = node[:cli][:database_name]

# Remove the VM cli directory, then create it
directory 'VM cli path check' do
    path "/home/#{user}/cli"
    recursive true
    action :delete
end

# Create the VM CLI directories
cli_directories.each do |directory_data|
    directory "Creating #{directory_data[:path]}" do
        path "#{directory_data[:path]}"
        owner "#{user}"
        group "#{group}"
        mode "#{directory_data[:mode]}"
        not_if { ::File.directory?("#{directory_data[:path]}") }
    end
end

# Copy the commands
template "VM CLI" do
    source "commands.sh.erb"
    path "/home/#{user}/cli/commands.sh"
    mode "755"
    owner "#{user}"
    group "#{group}"
    variables ({
        user: "#{user}",
        web_root: "#{web_root}",
        php_version: "#{php_version}",
        db_host: "#{db_host}",
        db_user: "#{db_user}",
        db_password: "#{db_password}",
        db_name: "#{db_name}",
        magento_version: "#{magento_version}",
        private_key_files: private_key_files
    })
    only_if { ::File.directory?("/home/#{user}/cli") }
end

# Copy the CLI files
cli_files.each do |cli_file_data|  
    cookbook_file "Copying file : #{cli_file_data[:source]}" do
        source "#{cli_file_data[:source]}"
        path "#{cli_file_data[:path]}"
        owner "#{user}"
        group "#{user}"
        mode "#{cli_file_data[:mode]}"
        action :create
    end
end
