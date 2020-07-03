#
# Cookbook:: ssh
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:ssh][:user]
group = node[:ssh][:user]
vagrant_key = node[:ssh][:vagrant_key]
private_keys = node[:ssh][:private_keys][:files]
authorized_keys = node[:ssh][:authorized_keys]

ssh "Stop the ssh-agent" do
    action :stop_ssh_agent
end

ssh "Clear the ssh directory" do
    action :clear_ssh_directory
    only_if { ::File.directory?("/home/#{user}/.ssh") }
end

ssh "Create ssh_config" do
    action :create_ssh_config
end

ssh "Add private and public ssh keys and restart" do
    action [:add_private_keys, :add_public_keys, :restart]
    configuration({
        vagrant_key: "#{vagrant_key}",
        private_keys: private_keys,
        authorized_keys: authorized_keys
    })
end
