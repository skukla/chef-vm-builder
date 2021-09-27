# Cookbook:: magento_patches
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento_patches][:nginx][:web_root]
build_action = node[:magento][:build][:action]
vendor_path = node[:magento_patches][:vendor_path]
directory_in_codebase = node[:magento_patches][:codebase_directory]

if build_action == 'update'
	magento_patch 'Revert existing patches' do
		action :revert_patches
		ignore_failure :quiet
		only_if do
			::Dir.exist?("#{web_root}/#{directory_in_codebase}") &&
				::Dir.exist?("#{web_root}/vendor/#{vendor_path}")
		end
	end
end

if %w[install force_install update].include?(build_action)
	include_recipe 'magento_patches::setup'
end
