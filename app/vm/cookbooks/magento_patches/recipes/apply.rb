# Cookbook:: magento_patches
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento_patches][:nginx][:web_root]
vendor_path = node[:magento_patches][:vendor_path]
codebase_directory = node[:magento_patches][:codebase_directory]

magento_patch 'Apply patches' do
	action :apply_patches
	ignore_failure :quiet
	only_if do
		::Dir.exist?("#{web_root}/#{codebase_directory}") &&
			::Dir.exist?("#{web_root}/vendor/#{vendor_path}")
	end
end
