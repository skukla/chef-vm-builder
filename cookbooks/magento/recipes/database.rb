#
# Cookbook:: magento
# Recipe:: database
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
db_host = node[:infrastructure][:database][:host]
db_user = node[:infrastructure][:database][:user]
db_password = node[:infrastructure][:database][:password]
db_name = node[:infrastructure][:database][:name]

ruby_block "Create the Magento database" do
    block do
        %x[mysql -uroot -e "CREATE DATABASE IF NOT EXISTS #{db_name};"]
    end
    action :create
end

ruby_block "Add permissions for database user" do
    block do
        %x[mysql -uroot -e "GRANT ALL ON #{db_name}.* TO '#{db_user}'@'#{db_host}' IDENTIFIED BY '#{db_password}' WITH GRANT OPTION;"]
    end
    action :create
end
