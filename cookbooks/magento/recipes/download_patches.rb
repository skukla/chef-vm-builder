#
# Cookbook:: magento
# Recipe:: download_patches
#
# 1. Add cweagans composer patches module
# 2. Clone repository and folder containing patches
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:vm][:user]
group = node[:vm][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]
magento_version = node[:application][:installation][:options][:version]
patches_repository = node[:application][:installation][:options][:patches][:repository_url]

# Include the cweagans composer patches module
execute "Download cweagans composer patches module" do
    command "cd #{web_root} && su #{user} -c '/#{composer_install_dir}/#{composer_file} require --no-update cweagans/composer-patches'"
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
