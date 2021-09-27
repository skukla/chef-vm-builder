# Cookbook:: magento_patches
# Recipe:: apply
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento_patches][:nginx][:web_root]
directory_in_codebase = node[:magento_patches][:codebase_directory]

magento_patch 'Apply patches' do
	action :apply_patches
	ignore_failure :quiet
	only_if do
		::Dir.exist?("#{web_root}/#{directory_in_codebase}") &&
			!::Dir.empty?("#{web_root}/#{directory_in_codebase}")
	end
end
