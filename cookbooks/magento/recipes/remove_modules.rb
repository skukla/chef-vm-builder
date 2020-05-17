#
# Cookbook:: magento
# Recipe:: remove_modules
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]
selected_modules = node[:magento][:installation][:build][:modules_to_remove]
composer_file = node[:magento][:composer_file]

ruby_block "Remove outdated core modules" do
    block do
        ModulesHelper.remove_modules(selected_modules, "#{web_root}/composer.json")
    end
    only_if { ::File.exist?("#{web_root}/composer.json") }
end
