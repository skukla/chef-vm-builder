#
# Cookbook:: samba
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

samba 'Install and configure samba' do
	action %i[install configure]
end
