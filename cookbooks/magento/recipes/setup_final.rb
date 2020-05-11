#
# Cookbook:: magento
# Recipe:: setup_final
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
group = node[:magento][:user]
web_root = node[:magento][:web_root]

# Reindex
execute "Reindex" do
    command "su #{user} -c '#{web_root}/bin/magento indexer:reset && #{web_root}/bin/magento indexer:reindex'"
end

# Update folder ownership
directories = ["var/", "pub/", "app/etc/", "generated/"]
directories.each do |directory|
    execute "Update #{directory} permissions" do
        command "sudo chown -R #{user}:#{group} #{web_root}/#{directory} && sudo chmod -R 777 #{web_root}/#{directory}"
    end
end

# Clean cache
execute "Clean config and full_page cache" do
    command "su #{user} -c '#{web_root}/bin/magento cache:clean full_page config'"
end