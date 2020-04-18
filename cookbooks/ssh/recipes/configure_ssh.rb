#
# Cookbook:: ssh
# Recipe:: add_keys_to_agent
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]

# Resources
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