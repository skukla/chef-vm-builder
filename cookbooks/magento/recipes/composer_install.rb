#
# Cookbook:: magento
# Recipe:: composer_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]
composer_file = node[:magento][:composer_file]

# Run composer install to download the code in composer.json
execute "Download Magento application code" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} install'"
end


