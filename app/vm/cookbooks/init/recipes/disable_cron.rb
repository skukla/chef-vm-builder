# Cookbook:: init
# Recipe:: disable_cron
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

build_action = node[:init][:magento][:build_action]

magento_cli 'Disable cron' do
	action :disable_cron
	only_if do
		::File.exist?("/var/spool/cron/crontabs/#{user}") &&
			build_action != 'install'
	end
end
