#
# Cookbook:: magento
# Recipe:: apply_patches
#
# 1. Add cweagans composer patches module
# 2. Clone repository containing patches (can I get just the folder?)
# 3. Scan the folder and get filenames 
# 4. Scan each file to find out affected Magento module
# 5. Write out patches.json file from filenames
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:vm][:user]
group = node[:vm][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]

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
