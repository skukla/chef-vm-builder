#
# Cookbook:: mysql
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
socket = node[:infrastructure][:database][:conf_options][:socket]
innodb_buffer_pool_size = node[:infrastructure][:database][:conf_options][:innodb_buffer_pool_size]
max_allowed_packet = node[:infrastructure][:database][:conf_options][:max_allowed_packet]
tmp_table_size = node[:infrastructure][:database][:conf_options][:tmp_table_size]
max_heap_table_size = node[:infrastructure][:database][:conf_options][:max_heap_table_size]
root_user_password = node[:infrastructure][:database][:root_user][:password]

# Create the mysql.conf.d folder
directory 'Create the mysql.conf.d folder' do
    path '/etc/mysql/mysql.conf.d'
    owner 'root'
    group 'root'
    mode '644'
end

# Configure MariaDB
template 'Configure MariaDB' do
    source 'my.cnf.erb'
    path '/etc/mysql/my.cnf'
    owner 'root'
    group 'root'
    mode '644'
    variables({
        socket: "#{socket}",
        innodb_buffer_pool_size: "#{innodb_buffer_pool_size}",
        max_allowed_packet: "#{max_allowed_packet}",
        tmp_table_size: "#{tmp_table_size}",
        max_heap_table_size: "#{max_heap_table_size}"
    })
end

# Allow SUPER privileges
ruby_block "Allow super privileges" do
    block do
        %x[mysql -uroot -e "SET GLOBAL log_bin_trust_function_creators = 1;"]
    end
    action :create
end

# Define, enable, and start the MySQL service
service 'mysql' do
    action [:enable, :start]
end
