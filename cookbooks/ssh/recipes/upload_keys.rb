#
# Cookbook:: ssh
# Recipe:: upload_keys
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
vagrant_ssh_key = node[:ssh][:vagrant_insecure_key]
private_keys = node[:ssh][:private_key_files]
authorized_keys = node[:ssh][:authorized_keys]

# Private keys to ./ssh/
unless private_keys.nil?
    private_keys.each do |private_key|
        cookbook_file "Adding private key file : #{private_key}" do
            source "keys/private/#{private_key}"
            path "/home/#{user}/.ssh/#{private_key}"
            owner "#{user}"
            group "#{group}"
            mode 0400
            sensitive true
            action :create_if_missing
        end
    end
end

# Read public keys to authorized_keys
unless authorized_keys.nil?
    template "Authorized keys configuration" do
        source "authorized_keys.erb"
        path "/home/#{user}/.ssh/authorized_keys"
        owner "#{user}"
        group "#{group}"
        mode '600'
        sensitive true
        variables ({ authorized_keys: authorized_keys })
    end
end