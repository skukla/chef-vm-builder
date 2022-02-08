# Cookbook:: mysql
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:mysql][:socket] = '/var/run/mysqld/mysqld.sock'
default[:mysql][:port] = 3306
default[:mysql][:innodb_buffer_pool_size] = '1G'
default[:mysql][:max_allowed_packet] = '512M'
default[:mysql][:tmp_table_size] = '64M'
default[:mysql][:max_heap_table_size] = '64M'
default[:mysql][:db_host] = 'localhost'
default[:mysql][:db_user] = 'magento'
default[:mysql][:db_password] = 'password'
default[:mysql][:db_name] = 'magento'
