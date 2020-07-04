#
# Cookbook:: ssh
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:ssh][:init][:user]
authorized_keys = node[:ssh][:authorized_keys]
private_keys = node[:ssh][:private_keys][:files]

ssh "Stop the ssh-agent" do
    action :stop_ssh_agent
end

ssh "Clear the ssh directory and create ssh_config" do
    action [:clear_ssh_directory, :create_ssh_config]
    only_if { ::File.directory?("/home/#{user}/.ssh") }
end

ssh "Add public keys to authorized_keys and private keys to .ssh/ and restart" do
    action [:add_public_keys, :add_private_keys, :restart]
    configuration({
        authorized_keys: authorized_keys,
        private_keys: private_keys
    })
end