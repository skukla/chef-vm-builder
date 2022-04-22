# Cookbook:: magento_patches
# Recipe:: setup
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

web_root = node[:magento_patches][:nginx][:web_root]
version = node[:magento_patches][:magento][:version]
patches_source = node[:magento_patches][:source]
repository_directory = node[:magento_patches][:repository_directory]
codebase_directory = node[:magento_patches][:codebase_directory]

magento_patch 'Prepare for Magento patches' do
	action %i[remove_holding_area remove_from_web_root]
end

magento_patch 'Create holding area' do
	action :create_holding_area
end

if patches_source != 'local'
	magento_patch 'Clone patches repository' do
		action :clone_patches_repository
	end

	magento_patch 'Filter patches' do
		action :filter_directory
	end
end

magento_patch 'Copy custom patches into place' do
	action :add_custom_patches
end

magento_patch 'Enable/disable sample data patches' do
	action :rename_patches
end

magento_patch 'Move patches into web root' do
	action :move_into_web_root
end

magento_app 'Update patch permissions in codebase' do
	action :set_permissions
	permission_dirs [codebase_directory]
	remove_generated false
	not_if { ::Dir.empty?("#{web_root}/#{codebase_directory}") }
end
