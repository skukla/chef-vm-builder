#
# Cookbook:: magento
# Recipe:: add_modules
#
# 1. Switch to developer mode
# 2. Run setup:upgrade
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:vm][:user]
group = node[:vm][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]

# Switch to developer mode
execute "Switch to developer mode" do
    command "cd #{web_root} && su #{user} -c './bin/magento deploy:mode:set developer'"
end

# Upgrade the database
execute "Upgrade the database" do
    command "cd #{web_root} && su #{user} -c './bin/magento setup:upgrade'"
end
