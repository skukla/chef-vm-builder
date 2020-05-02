#
# Cookbook:: ssh
# Recipe:: add_keys_to_agent
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
private_keys = node[:ssh][:private_key_files]

unless private_keys.nil?
    private_keys.each do |private_key|
        execute "Adding #{private_key} to the ssh agent" do
            command "su #{user} -c 'eval \"$(ssh-agent -s)\" && ssh-add /home/#{user}/.ssh/#{private_key}'"
            only_if { ::File.exists?("/home/#{user}/.ssh/#{private_key}") }
        end
    end
end