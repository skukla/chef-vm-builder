#
# Cookbook:: cli
# Resource:: cli
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :vm_cli
provides :vm_cli

property :name,                     String,                                    name_property: true
property :user,                     String,                                    default: node[:vm_cli][:init][:user]
property :group,                    String,                                    default: node[:vm_cli][:init][:user]
property :webserver_type,           String,                                    default: node[:vm_cli][:init][:webserver_type]
property :web_root,                 String,                                    default: node[:vm_cli][:init][:web_root]
property :demo_structure,           Hash,                                      default: node[:vm_cli][:init][:demo_structure]
property :php_version,              String,                                    default: node[:vm_cli][:php][:version]
property :magento_version,          String,                                    default: node[:vm_cli][:magento][:version]
property :use_secure_frontend,      [Integer, TrueClass, FalseClass, String],  default: node[:vm_cli][:magento][:use_secure_frontend]
property :db_host,                  String,                                    default: node[:vm_cli][:mysql][:db_host]
property :db_user,                  String,                                    default: node[:vm_cli][:mysql][:db_user]
property :db_password,              String,                                    default: node[:vm_cli][:mysql][:db_password]
property :db_name,                  String,                                    default: node[:vm_cli][:mysql][:db_name]
property :vm_cli_directories,       Array,                                     default: node[:vm_cli][:directories]
property :vm_cli_files,             Array,                                     default: node[:vm_cli][:files]
property :consumer_list,            Array,                                     default: node[:vm_cli][:magento][:consumer_list]
property :command_list,             [String, Array]

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
  protocol = new_resource.use_secure_frontend ? 'http' : 'https'
  template 'VM CLI' do
    source 'commands.sh.erb'
    path "/home/#{new_resource.user}/cli/commands.sh"
    mode '755'
    owner new_resource.user
    group new_resource.group
    variables({
                user: new_resource.user,
                urls: DemoStructureHelper.get_vhost_urls(new_resource.demo_structure).map { |url| "\"#{protocol}://#{url}/\"" }.join(' '),
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
      code <<-CONTENT
                source /home/#{new_resource.user}/cli/commands.sh
                #{command}
      CONTENT
      cwd new_resource.web_root
    end
  end
end
