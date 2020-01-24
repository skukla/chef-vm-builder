#
# Cookbook:: init
# Recipe:: install_cli
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Create the VM cli directory
directory 'VM cli path' do
    owner "#{node[:vm][:user]}"
    group "#{node[:vm][:group]}"
    path "/home/#{node[:vm][:user]}/cli"
    action :create
    not_if { ::File.directory?("/home/#{node[:vm][:user]}/cli") }
end

# Clone the VM cli from Steve's public git repo
git 'VM cli repository' do
    repository 'https://github.com/skukla/vm-dotfiles.git'
    revision 'master'
    destination "/home/#{node[:vm][:user]}/cli"
    action :sync
    user "#{node[:vm][:user]}"
    group "#{node[:vm][:group]}"
end

# Copy the .bashrc file with the cli bash functions
execute 'Install cli' do
    command "cp /home/#{node[:vm][:user]}/cli/.bashrc /home/#{node[:vm][:user]}/.bashrc"
end
