#
# Cookbook:: magento
# Recipe:: setup_initial
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]

# Set indexers on schedule
execute "Configure indexer modes" do
    command "su #{user} -c '#{web_root}/bin/magento indexer:set-mode schedule'"
end