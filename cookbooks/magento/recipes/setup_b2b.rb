#
# Cookbook:: magento
# Recipe:: setup_b2b
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]

# Set catalog permission indexers on schedule
execute "Configure indexer modes" do
    command "su #{user} -c '#{web_root}/bin/magento indexer:set-mode schedule catalogpermissions_category catalogpermissions_product'"
end
