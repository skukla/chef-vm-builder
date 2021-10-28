# Cookbook:: samba
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

samba 'Install and configure samba' do
	action %i[install configure]
end
