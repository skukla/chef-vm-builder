#
# Cookbook:: init
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
update_os = node[:init][:os][:update]

os 'Update OS' do
	action :update
	only_if { update_os }
end

os 'Configure OS' do
	action %i[configure add_os_packages]
end
