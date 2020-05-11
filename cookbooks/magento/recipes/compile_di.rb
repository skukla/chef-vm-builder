#
# Cookbook:: magento
# Recipe:: compile_di
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]

execute "Compile dependencies" do
    command "su #{user} -c '#{web_root}/bin/magento setup:di:compile'"
end