#
# Cookbook:: ssh
# Recipe:: add_keys_to_agent
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:infrastructure][:ssh][:user]
group = node[:infrastructure][:ssh][:group]
ssh_keys = node[:application][:authentication][:ssh_keys]

# Recipes
ssh_keys.each do |key_file|
    execute "Adding #{key_file} to the ssh agent" do
        command "su #{user} -c 'ssh-add /home/#{user}/.ssh/#{key_file}'"
        only_if { ::File.exists?("/home/#{user}/.ssh/#{key_file}") }
    end
end
