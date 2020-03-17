#
# Cookbook:: magento
# Recipe:: apply-patches
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:vm][:user]
group = node[:vm][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]

# Include the cweagans composer patches module
execute "Download CWeagans Composer Patches Module" do
    command "cd #{web_root} && su #{user} -c '/#{composer_install_dir}/#{composer_file} require --no-update cweagans/composer-patches'"
    not_if { ::File.directory?("#{web_root}/vendor/cweagans") }
end

# Clone the patches via github
git 'Magento patches' do
    repository 'https://github.com/skukla/m2-patches.git'
    revision 'master'
    destination "#{web_root}/m2-patches"
    action :sync
    user "#{user}"
    group "#{group}"
end

# Create m2-hotfixes folder
directory 'Hotfix directory' do
    path "#{web_root}/m2-hotfixes"
    owner "#{user}"
    group "#{group}"
    mode '755'
    action :create
    not_if { ::File.directory?("#{web_root}/m2-hotfixes") }
end

# Copy patches to m2-hotfixes folder
execute "Copy patches to m2-hotfixes folder" do
    command "cd #{web_root} && cp m2-patches/patches.json m2-hotfixes/ && cp m2-patches/kukla-patches/* m2-hotfixes/"
    only_if { ::File.directory?("#{web_root}/m2-hotfixes") }
end

# Update the composer file
execute "Add the patches file to composer.json" do
    command "cd #{web_root} && su #{user} -c '/#{composer_install_dir}/#{composer_file} config extra.patches-file m2-hotfixes/patches.json'"
end
