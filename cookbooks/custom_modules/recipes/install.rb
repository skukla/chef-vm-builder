#
# Cookbook:: custom_modules
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:custom_modules][:user]
group = node[:custom_modules][:user]
web_root = node[:custom_modules][:web_root]
composer_file = node[:custom_modules][:composer][:filename]

# Run composer install to download the code in composer.json
execute "Download custom module code" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} update'"
end

# Upgrade the database
execute "Upgrade the database" do
    command "su #{user} -c '#{web_root}/bin/magento setup:upgrade'"
end