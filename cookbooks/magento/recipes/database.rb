#
# Cookbook:: magento
# Recipe:: database
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
db_host = node[:magento][:database][:host]
db_user = node[:magento][:database][:user]
db_password = node[:magento][:database][:password]
db_name = node[:magento][:database][:name]

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
