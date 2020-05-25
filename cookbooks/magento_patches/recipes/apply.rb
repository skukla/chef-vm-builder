#
# Cookbook:: magento_patches
# Recipe:: apply
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_patches][:user]
group = node[:magento_patches][:user]
web_root = node[:magento_patches][:web_root]
composer_file = node[:magento_patches][:composer][:file]
directory_in_codebase = node[:magento_patches][:codebase_directory]
patches_file = node[:magento_patches][:patches_file]

# Create the patch file
ruby_block "Build patch file" do
    block do
        PatchHelper.build_patch_file("#{web_root}/#{directory_in_codebase}", "#{web_root}/#{directory_in_codebase}/#{patches_file}")
    end
    only_if { Dir.exist?("#{web_root}/#{directory_in_codebase}") }
end

# Update patch permissions
magento_app "Update patch permissions" do
    action :set_permissions
    permission_dirs ["#{web_root}/#{directory_in_codebase}"]
    only_if { ::Dir.exist?("#{web_root}/#{directory_in_codebase}") }
end

# Update the composer file
composer "Update composer.json extra section with patches file" do
    action :config_extra
    extra_content "#{directory_in_codebase}/#{patches_file}"
    only_if { ::Dir.exist?("#{web_root}/#{directory_in_codebase}") }
end
