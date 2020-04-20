#
# Cookbook:: magento
# Recipe:: set_deploy_mode
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:application][:installation][:options][:directory]
deploy_mode = node[:application][:installation][:options][:deploy_mode][:mode]

# Set application deployment mode
execute "Set application mode" do
    command "su #{user} -c '#{web_root}/bin/magento deploy:mode:set #{deploy_mode}'"
end