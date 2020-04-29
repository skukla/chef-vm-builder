#
# Cookbook:: magento
# Recipe:: download_b2b
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
web_root = node[:magento][:installation][:options][:directory]
composer_file = node[:magento][:composer_filename]

execute "Download B2B module" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} require --no-update magento/extension-b2b:^1.0'"
end
