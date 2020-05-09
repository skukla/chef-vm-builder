#
# Cookbook:: magento
# Recipe:: download_patches
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:app_patches][:user]
group = node[:app_patches][:user]
patches_repository = node[:app_patches][:repository_url]
web_root = node[:magento][:installation][:options][:directory]
magento_version = node[:magento][:installation][:options][:version]
composer_file = node[:magento][:composer_filename]

# Include the cweagans composer patches module
execute "Download cweagans composer patches module" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} require --no-update cweagans/composer-patches'"
    not_if { ::File.directory?("#{web_root}/vendor/cweagans") }
end

# Remove patches directory if it exists
execute "Remove patches directory" do
    command "sudo rm -rf /var/www/patches"
    only_if { ::File.directory?('/var/www/patches') }
end

# Remove patches from web root if they exist
execute "Remove patches from web root" do
    command "sudo rm -rf #{web_root}/m2-hotfixes"
    only_if { ::File.directory?("#{web_root}/m2-hotfixes") }
end

# Clone the patches repository via github
git 'Magento patches' do
    repository "#{patches_repository}"
    revision "pmet-#{magento_version}-ref"
    destination "/var/www/patches"
    action :sync
    user 'root'
    group 'root'
end
