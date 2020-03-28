#
# Cookbook:: magento
# Recipe:: configure_app_base
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
use_elasticsearch = node[:infrastructure][:elasticsearch][:use]
base_configuration = node[:application][:installation][:conf_options]
custom_module_configuration = node[:application][:installation][:custom_modules][:conf_options]
apply_config_flag = node[:application][:installation][:options][:configuration][:apply]

# Update files/folders ownership
execute "Set permissions" do
    command "cd #{web_root} && su #{user} -c 'sudo chown -R #{group}:#{user} var/cache/ var/page_cache/ && sudo chmod -R 777 var/ pub/ app/etc/ generated/'"
end

# Configure cron
execute "Configure cron" do
    command "cd #{web_root} && su #{user} -c './bin/magento cron:install'"
    not_if "su #{user} -c 'crontab -l'"
end

# Start Consumers
general_consumers = [
    'product_action_attribute.update',
    'product_action_attribute.website.update',
    'codegeneratorProcessor',
    'exportProcessor',
    'inventoryQtyCounter'
]
consumers_string = general_consumers.join(' ')
execute "Start General Consumers" do
    command "cd #{web_root} && su #{user} -c './bin/magento queue:consumers:start #{consumers_string} &'"
end

# Configure base application according to settings
if apply_config_flag
    base_configuration.each do |setting|
        if setting[:path].include? "elasticsearch"
            if use_elasticsearch
                execute "Configuring base setting : #{setting[:path]}" do
                    command "cd #{web_root} && su #{user} -c './bin/magento config:set #{setting[:path]} \"#{setting[:value]}\"'"
                end
            end
        else
            execute "Configuring base setting : #{setting[:path]}" do
                command "cd #{web_root} && su #{user} -c './bin/magento config:set #{setting[:path]} \"#{setting[:value]}\"'"
            end
        end
    end
end

execute "Clean cache" do
    command "cd #{web_root} && su #{user} -c './bin/magento cache:clean config full_page'"
end

# Set indexers on schedule
execute "Configure indexer modes" do
    command "cd #{web_root} && su #{user} -c './bin/magento indexer:set-mode schedule'"
end
