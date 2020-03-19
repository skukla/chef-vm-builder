#
# Cookbook:: magento
# Recipe:: configure-app
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
use_elasticsearch = node[:infrastructure][:elasticsearch][:use]
deploy_mode = node[:application][:installation][:options][:mode]
elasticsearch_options = node[:application][:elasticsearch][:conf_options]

# Update files/folders ownership
execute "Set permissions" do
    command "cd #{web_root} && su #{user} -c 'sudo chown -R #{group}:#{user} var/cache/ var/page_cache/ && sudo chmod -R 777 var/ pub/ app/etc/ generated/'"
end

# Set application deployment mode
unless deploy_mode.empty?
    execute "Set application mode" do
        command "cd #{web_root} && su #{user} -c './bin/magento deploy:mode:set #{deploy_mode}'"
    end
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

# If Elasticsearch is used, configure it for use in Magento
if use_elasticsearch
    elasticsearch_options.each do |key, setting|    
        execute "Configure Magento to use Elasticsearch" do
            command "cd #{web_root} && su #{user} -c './bin/magento config:set #{setting[:path]} #{setting[:value]}'"
        end
    end
end

# Set indexers on schedule
execute "Configure indexer modes" do
    command "cd #{web_root} && su #{user} -c './bin/magento indexer:set-mode schedule'"
end
