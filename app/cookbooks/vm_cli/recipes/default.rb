#
# Cookbook:: cli
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
vm_cli 'Install VM CLI' do
  action %i[create_directories install]
end
