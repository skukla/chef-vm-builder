#
# Cookbook:: ssh
# Recipe:: upload_keys
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
key_filepath = "/var/chef/cache/cookbooks/ssh/files/keys"
configured_private_key_files = node[:application][:authentication][:ssh][:private_key_files]
private_key_files_in_folder = Dir["#{key_filepath}/private/*"]
public_key_files_in_folder = Dir["#{key_filepath}/public/*"]
configured_public_key_files = node[:application][:authentication][:ssh][:public_key_files]
vagrant_ssh_key = node[:infrastructure][:ssh][:vagrant_insecure_key]

# Private keys to ./ssh/
configured_private_key_files.each do |private_key_file|
    if private_key_files_in_folder.include?("#{key_filepath}/private/#{private_key_file}")
        cookbook_file "Adding private key file : #{private_key_file}" do
            source "keys/private/#{private_key_file}"
            path "/home/#{user}/.ssh/#{private_key_file}"
            owner "#{user}"
            group "#{group}"
            mode 0400
            sensitive true
            action :create_if_missing
        end
    end
end        

# Read public keys to authorized_keys
verified_keys = Array.new
verified_keys << vagrant_ssh_key
configured_public_key_files.each do |public_key_file|
    if public_key_files_in_folder.include?("#{key_filepath}/public/#{public_key_file}")
        key_content = File.readlines("#{key_filepath}/public/#{public_key_file}")
        if key_content[0].include?("ssh-rsa")
            verified_keys << key_content[0]
        end
    end
end
verified_keys.each do |verified_key|
    template "Authorized keys configuration" do
        source "authorized_keys.erb"
        path "/home/#{user}/.ssh/authorized_keys"
        owner "#{user}"
        group "#{group}"
        mode '600'
        sensitive true
        variables ({ authorized_keys: verified_keys })
    end
end