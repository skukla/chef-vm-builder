#
# Cookbook:: mysql
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
configuration = {
    socket: node[:mysql][:socket],
    innodb_buffer_pool_size: node[:mysql][:innodb_buffer_pool_size],
    max_allowed_packet: node[:mysql][:max_allowed_packet],
    tmp_table_size: node[:mysql][:tmp_table_size],
    max_heap_table_size: node[:mysql][:max_heap_table_size]
}

mysql "Install and enable MySQL" do
    action [:install, :enable]
end

mysql "Configure MySQL" do
    action :configure
    configuration configuration
end