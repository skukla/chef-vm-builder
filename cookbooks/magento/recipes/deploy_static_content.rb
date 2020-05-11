#
# Cookbook:: magento
# Recipe:: deploy_static_content
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
web_root = node[:magento][:web_root]

execute "Deploy static content" do
    command "su #{user} -c '#{web_root}/bin/magento setup:static-content:deploy -f'"
end