#
# Cookbook:: magento
# Recipe:: configure_app_post_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
custom_module_data = node[:custom_modules]
deploy_mode = node[:application][:installation][:options][:deploy_mode][:mode]
base_configuration = node[:application][:installation][:conf_options]
custom_module_configuration = node[:application][:installation][:custom_modules][:conf_options]
apply_config_flag = node[:application][:installation][:options][:configuration][:apply]
apply_deploy_mode_flag = node[:application][:installation][:options][:deploy_mode][:apply]

# Configure third-party modules according to settings
if apply_config_flag
    custom_module_configuration.each do |setting|
        execute "Configuring custom module setting : #{setting[:path]}" do
            command "cd #{web_root} && su #{user} -c './bin/magento config:set #{setting[:path]} \"#{setting[:value]}\"'"
        end
    end
end

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
