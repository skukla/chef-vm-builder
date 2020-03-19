#
# Cookbook:: magento
# Recipe:: configure-app
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]

# Update files/folders ownership
execute "Set permissions" do
    command "cd #{web_root} && su #{user} -c 'sudo chown -R #{group}:#{user} var/cache/ var/page_cache/ && sudo chmod -R 777 var/ pub/ app/etc/ generated/'"
end

# Reindex
execute "Reindex" do
    command "cd #{web_root} && su #{user} -c './bin/magento indexer:reset && ./bin/magento indexer:reindex'"
end

# Clean cache
execute "Clean cache" do
    command "cd #{web_root} && su #{user} -c './bin/magento cache:clean && rm -rf var/cache/* var/page_cache/*'"
end
