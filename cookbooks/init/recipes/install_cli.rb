#
# Cookbook:: init
# Recipe:: install_cli
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:vm][:user]
group = node[:vm][:group]

# Remove the VM cli directory, then create it
directory 'VM cli path check' do
    path "/home/#{user}/cli"
    recursive true
    action :delete
end

# Create the VM cli directory
directory 'Create VM cli path   ' do
    owner "#{user}"
    group "#{group}"
    path "/home/#{user}/cli"
    action :create
end

# Clone the VM cli from Steve's public git repo
git 'VM cli repository' do
    repository 'https://github.com/skukla/vm-dotfiles.git'
    revision 'master'
    destination "/home/#{user}/cli"
    action :sync
    user "#{user}"
    group "#{group}"
end

# Copy the .bashrc file with the cli bash functions
execute 'Install cli' do
    command "cp /home/#{user}/cli/.bashrc /home/#{user}/.bashrc"
    only_if { ::File.exists?("/home/#{user}/cli/.bashrc") }
end

# Set scripts executable
directory 'Scripts directory' do
    path "/home/#{user}/cli/scripts"
    mode '777'
    recursive true
    action :create
    only_if { ::File.directory?("/home/#{user}/cli/scripts") }
end
