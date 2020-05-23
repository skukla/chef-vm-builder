#
# Cookbook:: magento_patches
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_patches][:user]
group = node[:magento_patches][:user]
web_root = node[:magento_patches][:web_root]
patches_repository = node[:magento_patches][:repository_url]
patches_branch = node[:magento_patches][:branch]
magento_version = node[:magento_patches][:magento_version]
composer_file = node[:magento_patches][:composer_file]
directory_in_repo = node[:magento_patches][:repository_directory]
directory_in_codebase = node[:magento_patches][:codebase_directory]
patches_holding_area = node[:magento_patches][:holding_area]

# Include the cweagans composer patches module
composer "Download CWeagans Composer Patches module" do
    action :require
    package_name "cweagans/composer-patches"
    options ["no-update"]
    only_if { !File.foreach("#{web_root}/composer.json").grep(/cweagans/).any? }
end

# Remove patches holding area if it exists
execute "Remove patches holding area" do
    command "sudo rm -rf #{patches_holding_area}"
    only_if { Dir.exist?("#{patches_holding_area}") }
end

# Remove patches from web root if they exist
execute "Remove patches from web root" do
    command "sudo rm -rf #{web_root}/#{directory_in_codebase}"
    only_if { Dir.exist?("#{web_root}/#{directory_in_codebase}") }
end

# Clone the patches repository via github
if patches_repository.include?("PMET-public")
    include_recipe "magento_internal::download_patches"
else
    git 'Downlaod custom patches' do
        repository "#{patches_repository}"
        revision "#{patches_branch}"
        destination "#{patches_holding_area}"
        enable_checkout patches_branch == "master" ? false : true
        action :sync
        user "#{user}"
        group "#{group}"
    end
end

# Pull out the patches subdirectory
execute "Pull out patches from repository" do
    command "cd #{patches_holding_area} && git filter-branch --subdirectory-filter #{directory_in_repo}"
end

# Move patches into web root
execute "Move patches into web root" do
    command "mv #{patches_holding_area} #{web_root}/#{directory_in_codebase}"
    only_if { ::Dir.exist?("#{patches_holding_area}") }
end