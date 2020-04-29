#
# Cookbook:: ssh
# Recipe:: add_keys_to_agent
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
ssh_keys = node[:application][:authentication][:ssh][:private_key_files]

# Resources
ssh_keys.each do |private_key_file|
    execute "Adding #{private_key_file} to the ssh agent" do
        command "su #{user} -c 'eval \"$(ssh-agent -s)\" && ssh-add /home/#{user}/.ssh/#{private_key_file}'"
        only_if { ::File.exists?("/home/#{user}/.ssh/#{private_key_file}") }
    end
end