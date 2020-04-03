#
# Cookbook:: mysql
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:infrastructure][:database][:conf_options] = {
    socket: '/var/run/mysqld/mysqld.sock',
    innodb_buffer_pool_size: '1G',
    max_allowed_packet: '512M',
    tmp_table_size: '64M',
    max_heap_table_size: '64M'
}
default[:infrastructure][:database][:root_user][:password] = 'password'
default[:infrastructure][:database][:pre_install_settings] = {
    log_bin_trust_function_creators: 1,
    autocommit: 0,
    unique_checks: 0,
    foreign_key_checks: 0
}
default[:infrastructure][:database][:post_install_settings] = {
    autocommit: 1,
    unique_checks: 1,
    foreign_key_checks: 1
}