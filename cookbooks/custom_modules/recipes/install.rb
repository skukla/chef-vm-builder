#
# Cookbook:: custom_modules
# Recipe:: install
#
# 1. Switch to developer mode
# 2. Run setup:upgrade
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
composer_file = node[:application][:composer][:filename]

# Run composer install to download the code in composer.json
execute "Download custom module code" do
    command "cd #{web_root} && su #{user} -c '#{composer_file} update'"
end

# Switch to developer mode
execute "Switch to developer mode" do
    command "su #{user} -c '#{web_root}/bin/magento deploy:mode:set developer'"
end

# Upgrade the database
execute "Upgrade the database" do
    command "su #{user} -c '#{web_root}/bin/magento setup:upgrade'"
end
