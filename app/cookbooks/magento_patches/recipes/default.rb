#
# Cookbook:: magento_patches
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento_patches][:init][:web_root]
patches_repository = node[:magento_patches][:repository_url]
directory_in_codebase = node[:magento_patches][:codebase_directory]

composer 'Add ECE Tools' do
  action :require
  package_name 'magento/ece-tools'
  module_name 'ece-tools'
  options ['no-update']
  only_if { ::File.foreach("#{web_root}/composer.json").grep(/ece-tools/).none? }
end

magento_patch 'Prepare for Magento patches' do
  action %i[
    remove_holding_area
    remove_from_web_root
  ]
end

magento_patch 'Create holding area' do
  action :create_holding_area
  only_if { patches_repository == 'local' || patches_repository.empty? }
end

magento_patch 'Clone and filter patches repository' do
  action %i[
    clone_patches_repository
    filter_directory
  ]
  not_if { patches_repository == 'local' || patches_repository.empty? }
end

magento_demo_builder 'Copy custom patches into place' do
  action :add_patches
end

magento_patch 'Move patches into web root' do
  action :move_into_web_root
end

magento_patch 'Enable/disable sample data patches' do
  action :rename_patches
end

magento_app 'Update patch permissions' do
  action :set_permissions
  permission_dirs [directory_in_codebase]
  remove_generated false
  not_if { ::Dir.empty?("#{web_root}/#{directory_in_codebase}") }
end
