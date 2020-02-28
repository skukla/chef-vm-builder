#
# Cookbook:: magento
# Recipe:: download
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
web_root = node[:application][:webserver][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]
b2b_module_version = node[:application][:installation][:options][:b2b_version]

# Include the B2B module
execute "Download B2B module" do
    command "cd #{web_root} && su #{user} -c '/#{composer_install_dir}/#{composer_file} require --no-update magento/extension-b2b:#{b2b_module_version}'"
end
