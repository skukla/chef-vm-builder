#
# Cookbook:: magento
# Recipe:: set_deploy_mode
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:magento][:web_root]
deploy_mode = node[:magento][:installation][:build][:deploy_mode][:mode]

execute "Set application mode" do
    command "su #{user} -c '#{web_root}/bin/magento deploy:mode:set #{deploy_mode}'"
end