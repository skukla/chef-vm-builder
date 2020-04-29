#
# Cookbook:: magento
# Recipe:: setup_final
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:magento][:installation][:options][:directory]

# Reindex
execute "Reindex" do
    command "su #{user} -c '#{web_root}/bin/magento indexer:reset && #{web_root}/bin/magento indexer:reindex'"
end

# Clean cache
execute "Clean config and full_page cache" do
    command "su #{user} -c '#{web_root}/bin/magento cache:clean full_page config'"
end