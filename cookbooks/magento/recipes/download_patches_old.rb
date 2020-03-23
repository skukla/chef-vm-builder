#
# Cookbook:: magento
# Recipe:: download_patches
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

# Include the cweagans composer patches module
execute "Download cweagans composer patches module" do
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
