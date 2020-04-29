#
# Cookbook:: magento
# Recipe:: uninstall_app
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
web_root = node[:application][:installation][:options][:directory]
db_name = node[:magento][:database][:name]

# Remove the web root
directory "Web root" do
    path "#{web_root}"
    recursive true
    action :delete
end

# Remove the database
ruby_block "Delete the Magento database" do
    block do
        %x[mysql -uroot -e "DROP DATABASE IF EXISTS #{db_name};"]
    end
    action :create
end
