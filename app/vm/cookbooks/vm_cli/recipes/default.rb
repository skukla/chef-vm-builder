#
# Cookbook:: vm_cli
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
vm_cli 'Creating VM CLI Directories' do
  action :create_directories
end

vm_cli 'Installing VM CLI' do
  action :install
end
