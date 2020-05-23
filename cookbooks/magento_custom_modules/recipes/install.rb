#
# Cookbook:: magento_custom_modules
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_custom_modules][:user]
group = node[:magento_custom_modules][:user]
web_root = node[:magento_custom_modules][:web_root]
composer_file = node[:magento_custom_modules][:composer_file]
custom_modules = node[:magento_custom_modules][:module_list]

# Run composer install to download the code in composer.json
composer "Download custom modules" do
    action :update 
end

# Upgrade the database
magento_cli "Upgrade Magento database" do
    action :db_upgrade 
end