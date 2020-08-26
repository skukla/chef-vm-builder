#
# Cookbook:: magento_patches
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento_patches][:init][:web_root]
patches_repository = node[:magento_patches][:repository_url]
directory_in_codebase = node[:magento_patches][:codebase_directory]
patches_file = node[:magento_patches][:patches_file]

composer "Download CWeagans Composer Patches module" do
    action :require
    package_name "cweagans/composer-patches"
    options ["no-update"]
    only_if { !::File.foreach("#{web_root}/composer.json").grep(/cweagans/).any? }
end

magento_patch "Prepare, clone, and filter Magento patches" do
    action [
        :remove_holding_area, 
        :remove_from_web_root, 
        :set_permissions,
        :clone_patches_repository,
        :filter_directory
    ]
end

magento_demo_builder "Copy custom patches into place" do
    action :add_patches
end

magento_patch "Move patches into web root" do
    action :move_into_web_root
end

magento_patch "Build patch file" do
    action :build_patch_file
    not_if { ::Dir.empty?("#{web_root}/#{directory_in_codebase}") }
end

magento_app "Update patch permissions" do
    action :set_permissions
    permission_dirs [directory_in_codebase]
    remove_generated false
    not_if { ::Dir.empty?("#{web_root}/#{directory_in_codebase}") }
end

composer "Update composer.json extra section with patches file" do
    action :config_extra
    extra_content "#{directory_in_codebase}/#{patches_file}"
    not_if { ::Dir.empty?("#{web_root}/#{directory_in_codebase}") }
end
