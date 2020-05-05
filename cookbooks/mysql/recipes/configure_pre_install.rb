#
# Cookbook:: mysql
# Recipe:: configure_pre_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
socket = node[:database][:socket]
innodb_buffer_pool_size = node[:database][:innodb_buffer_pool_size]
max_allowed_packet = node[:database][:max_allowed_packet]
tmp_table_size = node[:database][:tmp_table_size]
max_heap_table_size = node[:database][:max_heap_table_size]
install_settings = node[:database][:install_settings]

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

# Configure pre-install settings
install_settings.each do |setting|
    value = 1 ? setting == "log_bin_trust_function_creators" : value = 0

    ruby_block "Configure MySQL pre-install setting : #{setting}" do
        block do
            "%x[mysql -uroot -e \"SET GLOBAL #{setting} = #{value};\"]"
        end
        action :create
    end
end

# Restart MySQL
service 'mysql' do
    action :restart
end
