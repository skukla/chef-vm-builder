#
# Cookbook:: mysql
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:database][:socket] = "/var/run/mysqld/mysqld.sock"
default[:database][:innodb_buffer_pool_size] = "1G"
default[:database][:max_allowed_packet] = "512M"
default[:database][:tmp_table_size] = "64M"
default[:database][:max_heap_table_size] = "64M"
default[:database][:install_settings] = ["log_bin_trust_function_creators", "autocommit", "unique_checks", "foreign_key_checks"]
