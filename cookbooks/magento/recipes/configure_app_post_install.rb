#
# Cookbook:: magento
# Recipe:: configure_app_post_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
deploy_mode = node[:application][:installation][:options][:deploy_mode][:mode]
apply_deploy_mode_flag = node[:application][:installation][:options][:deploy_mode][:apply]

# Update files/folders ownership
execute "Set permissions" do
    command "cd #{web_root} && su #{user} -c 'sudo chown -R #{group}:#{user} var/cache/ var/page_cache/ && sudo chmod -R 777 var/ pub/ app/etc/ generated/'"
end

# Set application deployment mode
if apply_deploy_mode_flag
    unless deploy_mode.empty?
        execute "Set application mode" do
            command "cd #{web_root} && su #{user} -c './bin/magento deploy:mode:set #{deploy_mode}'"
        end
    end
end

# Reindex
execute "Reindex" do
    command "cd #{web_root} && su #{user} -c './bin/magento indexer:reset && ./bin/magento indexer:reindex'"
end

# Clean cache
execute "Clean cache" do
    command "cd #{web_root} && su #{user} -c './bin/magento cache:flush && sudo rm -rf var/cache/* var/page_cache/*'"
end
