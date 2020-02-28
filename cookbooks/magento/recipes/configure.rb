#
# Cookbook:: magento
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:application][:webserver][:web_root]
use_elasticsearch = node[:infrastructure][:elasticsearch][:use]
deploy_mode = node[:application][:installation][:options][:mode]

# TODO: Configure Magento to work with nginx

# TODO: Uncomment include of Magento nginx configurations from all virtual hosts

# Set application deployment mode
unless deploy_mode.empty?
    execute "Set application mode" do
        command "cd #{web_root} && ./bin/magento deploy:mode:set #{deploy_mode}"
    end
end

# Update files/folders ownership
execute "Set permissions" do
    command "cd #{web_root} && sudo chown -R #{group}:#{user} var/cache/ var/page_cache/ && sudo chmod -R 777 var/ pub/ app/etc/ generated/"
end

# If Elasticsearch is installed and being used, configure it for use in Magento
# if use_elasticsearch
#     execute "Configure Magento to use Elasticsearch" do
#         command "cd #{web_root} && bin/magento config:set system/full_page_cache/caching_application 2"
#     end
# end
