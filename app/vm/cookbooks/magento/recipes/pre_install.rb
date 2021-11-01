# Cookbook:: magento
# Recipe:: install
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento][:nginx][:web_root]
build_action = node[:magento][:build][:action]

if %w[restore].include?(build_action)
	magento_app 'Preparing to install after restoring backup' do
		action :prepare_restore
		only_if { ::Dir.exist?("#{web_root}/pub") }
	end
end

if %w[reinstall restore].include?(build_action)
	magento_app 'Preparing reinstall' do
		action :prepare_reinstall
		only_if { ::File.exist?("#{web_root}/app/etc/env.php") }
	end
end
