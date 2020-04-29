#
# Cookbook:: magento
# Recipe:: setup_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
web_root = node[:magento][:installation][:options][:directory]

# Configure cron
execute "Configure cron" do
    command "su #{user} -c '#{web_root}/bin/magento cron:install'"
    not_if "su #{user} -c 'crontab -l'"
end

# Set indexers on schedule
execute "Configure indexer modes" do
    command "su #{user} -c '#{web_root}/bin/magento indexer:set-mode schedule'"
end
