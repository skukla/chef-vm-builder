#
# Cookbook:: magento_patches
# Recipe:: apply
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_patches][:user]
group = node[:magento_patches][:user]
web_root = node[:magento_patches][:web_root]
composer_file = node[:magento_patches][:composer_file]
directory_in_codebase = node[:magento_patches][:codebase_directory]
patches_file = node[:magento_patches][:patches_file]

# Create the patch file
ruby_block 'Build patch file' do
    block do
        PatchesHelper.build_patch_file("#{web_root}/#{directory_in_codebase}", "#{web_root}/#{directory_in_codebase}/#{patches_file}")
    end
    only_if { ::File.directory?("#{web_root}/#{directory_in_codebase}") }
end

# Update patch permissions
execute "Update patch permissions" do
    command "sudo chown #{user}:#{group} -R #{web_root}/#{directory_in_codebase}"
    only_if { ::File.directory?("#{web_root}/#{directory_in_codebase}") }
end

# Update the composer file
execute "Add the patches file to composer.json" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} config extra.patches-file #{directory_in_codebase}/#{patches_file}'"
end
