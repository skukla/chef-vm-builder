#
# Cookbook:: ssh
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
ssh "Prepare ssh" do
    action [:stop_ssh_agent, :clear_ssh_directory, :create_ssh_config,]
end

ssh "Manage ssh keys and restart" do
    action [:add_public_keys, :restart]
end