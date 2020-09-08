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
    template "Authorized keys configuration" do
        source "authorized_keys.erb"
        path "/home/#{new_resource.user}/.ssh/authorized_keys"
        owner new_resource.user
        group new_resource.group
        mode "600"
        sensitive true
    end
end

action :restart do
    service "ssh" do
        action :restart
    end
end