#
# Cookbook:: ssh
# Recipe:: add_keys_to_agent
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:ssh][:user]
group = node[:ssh][:user]
private_keys = node[:ssh][:private_key_files]
vagrant_key = node[:ssh][:vagrant_key]
authorized_keys = node[:ssh][:authorized_keys]

execute "Stop ssh-agent and previously-active keys" do
    command "ssh-add -D"
end

execute "Clear /home/#{user}/.ssh directory" do
    command "rm -rf /home/#{user}/.ssh/*"
    only_if { ::File.directory?("/home/#{user}/.ssh") }
end

# /.ssh/config
template "SSH configuration" do
    source 'ssh.conf.erb'
    path "/home/#{user}/.ssh/config"
    owner "#{user}"
    group "#{group}"
    mode '600'
end

# Add private keys to ./ssh/ and ssh-agent
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

        execute "Add #{private_key} to the ssh agent" do
            command "su #{user} -c 'ssh-add /home/#{user}/.ssh/#{private_key}'"
            only_if { ::File.exist?("/home/#{user}/.ssh/#{private_key}") }
        end
    end
end

# Add public keys to authorized_keys
unless authorized_keys.nil?
    template "Authorized keys configuration" do
        source "authorized_keys.erb"
        path "/home/#{user}/.ssh/authorized_keys"
        owner "#{user}"
        group "#{group}"
        mode '600'
        sensitive true
        variables ({ 
            vagrant_key: "#{vagrant_key}",
            authorized_keys: authorized_keys 
        })
    end
end

service 'ssh' do
    action :restart
end