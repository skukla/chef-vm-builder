#
# Cookbook:: ssh
# Recipe:: add_keys_to_agent
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:infrastructure][:ssh][:user]
group = node[:infrastructure][:ssh][:group]

# Recipes
template "SSH configuration" do
    source 'ssh.conf.erb'
    path "/home/#{user}/.ssh/config"
    owner "#{user}"
    group "#{group}"
    mode '600'
end

service 'ssh' do
    action :restart
end

ruby_block "Automate ssh-agent startup" do
    block do
        file = Chef::Util::FileEdit.new("/home/#{user}/.bashrc")
        file.insert_line_if_no_match(/SSH_AUTH_SOCK/, "[ -z \"$SSH_AUTH_SOCK\" ] && eval \"$(ssh-agent -s)\"")
        file.write_file
    end
    only_if { ::File.exists?("/home/#{user}/.bashrc") }
end