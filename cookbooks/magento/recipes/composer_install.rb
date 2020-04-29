#
# Cookbook:: magento
# Recipe:: composer_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
composer_file = node[:magento][:composer][:filename]

# Run composer install to download the code in composer.json
execute "Download Magento application code" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} install'"
end


