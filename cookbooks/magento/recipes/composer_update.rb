#
# Cookbook:: magento
# Recipe:: composer_update
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
web_root = node[:application][:webserver][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]

# Run composer install to download the code in composer.json
execute "Download Magento application code" do
    command "cd #{web_root} && su #{user} -c '/#{composer_install_dir}/#{composer_file} update'"
end


