# Cookbook:: mysql
# Resource:: mysql
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

resource_name :mysql
provides :mysql

property :name, String, name_property: true
property :db_host, String, default: node[:mysql][:db_host]
property :db_user, String, default: node[:mysql][:db_user]
property :db_password, String, default: node[:mysql][:db_password]
property :db_name, String, default: node[:mysql][:db_name]
property :db_dump, String
property :db_query, String
property :socket, String, default: node[:mysql][:socket]
property :innodb_buffer_pool_size,
         [String, Integer],
         default: node[:mysql][:innodb_buffer_pool_size]
property :max_allowed_packet,
         [String, Integer],
         default: node[:mysql][:max_allowed_packet]
property :tmp_table_size,
         [String, Integer],
         default: node[:mysql][:tmp_table_size]
property :max_heap_table_size,
         [String, Integer],
         default: node[:mysql][:max_heap_table_size]

action :install do
	apt_package 'mysql-server' do
		action :install
		not_if { ::Dir.exist?('/etc/mysql') }
	end
end

action :configure do
	directory 'Create the mysql.conf.d folder' do
		path '/etc/mysql/mysql.conf.d'
		owner 'root'
		group 'root'
		mode '644'
	end

	template 'Configure MariaDB' do
		source 'my.cnf.erb'
		path '/etc/mysql/my.cnf'
		owner 'root'
		group 'root'
		mode '644'
		variables(
			{
				socket: new_resource.socket,
				innodb_buffer_pool_size: new_resource.innodb_buffer_pool_size,
				max_allowed_packet: new_resource.max_allowed_packet,
				tmp_table_size: new_resource.tmp_table_size,
				max_heap_table_size: new_resource.max_heap_table_size,
			},
		)
	end
end

action :restart do
	service 'mysql' do
		action :restart
	end
end

action :enable do
	service 'mysql' do
		action :enable
	end
end

action :create_database do
	ruby_block "Create the #{new_resource.db_name} database and #{new_resource.db_user} user" do
		block do
			DatabaseHelper.execute_query(
				"CREATE DATABASE IF NOT EXISTS #{new_resource.db_name}",
			)
			DatabaseHelper.execute_query(
				"CREATE USER IF NOT EXISTS '#{new_resource.db_user}'@'#{new_resource.db_host}' IDENTIFIED BY '#{new_resource.db_password}'",
			)
			DatabaseHelper.execute_query(
				"GRANT ALL PRIVILEGES ON * . * TO '#{new_resource.db_user}'@'#{new_resource.db_host}'",
			)
		end
		action :create
	end
end

action :drop_all_databases do
	db_list = DatabaseHelper.db_list
	ruby_block 'Dropping all databases' do
		block do
			db_list.each do |db|
				DatabaseHelper.execute_query("DROP DATABASE IF EXISTS #{db}")
				puts "Dropped the #{db} database."
			end
		end
		action :create
		not_if { db_list.empty? }
	end
end

action :drop_extra_databases do
	extra_db_list = DatabaseHelper.extra_db_list
	ruby_block 'Dropping extra databases' do
		block do
			extra_db_list.each do |db|
				DatabaseHelper.execute_query("DROP DATABASE IF EXISTS #{db}")
				puts "Dropped the #{db} database."
			end
		end
		action :create
		not_if { extra_db_list.empty? }
	end
end

action :run_query do
	ruby_block "Executing MySQL query on the #{new_resource.db_name} database" do
		block { DatabaseHelper.execute_query(new_resource.db_query) }
		only_if { DatabaseHelper.db_exists?(new_resource.db_name) }
	end
end

action :restore_dump do
	ruby_block "Restoring the #{new_resource.db_name} database from #{new_resource.db_dump}" do
		block do
			DatabaseHelper.restore_dump(
				new_resource.db_user,
				new_resource.db_password,
				new_resource.db_name,
				new_resource.db_dump,
			)
		end
		only_if { DatabaseHelper.db_exists?(new_resource.db_name) }
	end
end
