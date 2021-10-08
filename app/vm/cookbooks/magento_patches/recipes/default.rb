# Cookbook:: magento_patches
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento_patches][:nginx][:web_root]
build_action = node[:magento][:build][:action]
vendor_path = node[:magento_patches][:vendor_path]
codebase_directory = node[:magento_patches][:codebase_directory]

if %w[update_all update_app].include?(build_action)
	magento_patch 'Revert existing patches' do
		action :revert_patches
		ignore_failure :quiet
		only_if do
			::Dir.exist?("#{web_root}/#{codebase_directory}") &&
				::Dir.exist?("#{web_root}/vendor/#{vendor_path}")
		end
	end
end

if %w[install force_install update_all update_app].include?(build_action)
	include_recipe 'magento_patches::setup'
end
