#
# Cookbook:: ssh
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
ssh "Prepare ssh, add keys, and restart" do
    action [
        :clear_ssh_directory, 
        :create_ssh_config,
        :add_public_keys,
        :restart
    ]
end