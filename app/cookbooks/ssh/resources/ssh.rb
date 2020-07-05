#
# Cookbook:: ssh
# Resource:: ssh 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :ssh
provides :ssh

property :name,                     String, name_property: true
property :user,                     String, default: node[:ssh][:init][:user]
property :group,                    String, default: node[:ssh][:init][:user]
property :vagrant_key,              String, default: node[:ssh][:vagrant_key]
property :private_keys_list,        Array,  default: node[:ssh][:private_keys][:files]
property :authorized_keys_list,     Array,  default: node[:ssh][:authorized_keys][:files]

action :stop_ssh_agent do
    execute "Stop ssh-agent and previously-active keys" do
        command "ssh-add -D"
    end
end

action :clear_ssh_directory do
    execute "Clear /home/#{new_resource.user}/.ssh directory" do
        command "rm -rf /home/#{new_resource.user}/.ssh/*"
        only_if { ::Dir.exist?("/home/#{new_resource.user}/.ssh") }
    end
end

action :create_ssh_config do
    template "SSH configuration" do
        source "ssh.conf.erb"
        path "/home/#{new_resource.user}/.ssh/config"
        owner "#{new_resource.user}"
        group "#{new_resource.group}"
        mode "600"
        only_if { ::Dir.exist?("/home/#{new_resource.user}/.ssh") }
    end
end

action :add_public_keys do
    unless new_resource.authorized_keys_list.nil?
        template "Authorized keys configuration" do
            source "authorized_keys.erb"
            path "/home/#{new_resource.user}/.ssh/authorized_keys"
            owner new_resource.user
            group new_resource.group
            mode "600"
            sensitive true
            variables ({ 
                vagrant_key: new_resource.vagrant_key,
                authorized_keys_list: new_resource.authorized_keys_list 
            })
        end
    end
end

action :add_private_keys do
    unless new_resource.private_keys_list.nil?
        new_resource.private_keys_list.each do |private_key|
            cookbook_file "Adding private key file : #{private_key}" do
                source "keys/private/#{private_key}"
                path "/home/#{new_resource.user}/.ssh/#{private_key}"
                owner new_resource.user
                group new_resource.group
                mode "0400"
                sensitive true
                action :create_if_missing
            end
    
            execute "Add #{private_key} to the ssh agent" do
                command "su #{new_resource.user} -c 'ssh-add /home/#{new_resource.user}/.ssh/#{private_key}'"
                only_if { ::File.exist?("/home/#{new_resource.user}/.ssh/#{private_key}") }
            end
        end
    end
end

action :restart do
    service "ssh" do
        action :restart
    end
end