#
# Cookbook:: magento
# Recipe:: configure_app_base
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]

# Update files/folders ownership
execute "Set permissions" do
    command "cd #{web_root} && su #{user} -c 'sudo chown -R #{group}:#{user} var/ && sudo chmod -R 777 var/ pub/ app/etc/ generated/ && sudo rm -rf generated/*'"
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

execute "Clean cache" do
    command "cd #{web_root} && su #{user} -c './bin/magento cache:clean config full_page'"
end

# Set indexers on schedule
execute "Configure indexer modes" do
    command "cd #{web_root} && su #{user} -c './bin/magento indexer:set-mode schedule'"
end
