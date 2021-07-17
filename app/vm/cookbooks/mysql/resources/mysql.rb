#
# Cookbook:: mysql
# Resource:: mysql
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :mysql
provides :mysql

property :name,                     String,            name_property: true
property :db_host,                  String,            default: node[:mysql][:db_host]
property :db_user,                  String,            default: node[:mysql][:db_user]
property :db_password,              String,            default: node[:mysql][:db_password]
property :db_name,                  String,            default: node[:mysql][:db_name]
property :db_dump,                  String
property :db_query,                 String
property :socket,                   String,            default: node[:mysql][:socket]
property :innodb_buffer_pool_size,  [String, Integer], default: node[:mysql][:innodb_buffer_pool_size]
property :max_allowed_packet,       [String, Integer], default: node[:mysql][:max_allowed_packet]
property :tmp_table_size,           [String, Integer], default: node[:mysql][:tmp_table_size]
property :max_heap_table_size,      [String, Integer], default: node[:mysql][:max_heap_table_size]
property :app_install_settings,     Array,             default: node[:mysql][:app_install_settings]

action :install do
  apt_repository 'MariaDB' do
    uri 'http://mirror.zol.co.zw/mariadb/repo/10.3/ubuntu'
    arch 'amd64'
    components ['main']
    distribution 'bionic'
    keyserver 'keyserver.ubuntu.com'
    key 'F1656F24C74CD1D8'
    deb_src true
    trusted true
    not_if { ::Dir.exist?('/etc/mysql') }
  end

  %w[mariadb-server mariadb-client].each do |package|
    apt_package package do
      action :install
      not_if { ::Dir.exist?('/etc/mysql') }
    end
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
    variables({
                socket: new_resource.socket,
                innodb_buffer_pool_size: new_resource.innodb_buffer_pool_size,
                max_allowed_packet: new_resource.max_allowed_packet,
                tmp_table_size: new_resource.tmp_table_size,
                max_heap_table_size: new_resource.max_heap_table_size
              })
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
  ruby_block "Create the #{new_resource.db_name} database" do
    block do
      `mysql --user=root -e "CREATE DATABASE IF NOT EXISTS #{new_resource.db_name};"`
      `mysql --user=root -e "GRANT ALL ON #{new_resource.db_name}.* TO '#{new_resource.db_user}'@'#{new_resource.db_host}' IDENTIFIED BY '#{new_resource.db_password}' WITH GRANT OPTION;"`
    end
    action :create
  end
end

action :drop_database do
  ruby_block "Drop the #{new_resource.db_name} database" do
    block do
      `mysql --user=root -e "DROP DATABASE IF EXISTS #{new_resource.db_name};"`
    end
    action :create
  end
end

action :configure_pre_app_install do
  new_resource.app_install_settings.each do |setting|
    value = 1 ? setting == 'log_bin_trust_function_creators' : value = 0

    ruby_block "Configure MySQL pre-install setting : #{setting}" do
      block do
        "%x[mysql --user=root -e \"SET GLOBAL #{setting} = #{value};\"]"
      end
      action :create
    end
  end
end

action :configure_post_app_install do
  new_resource.app_install_settings.each do |setting|
    next if setting == 'log_bin_trust_function_creators'

    ruby_block "Configure MySQL post-install setting : #{setting}" do
      block do
        "%x[mysql --user=root -e \"SET GLOBAL #{setting} = 1;\"]"
      end
      action :create
    end
  end
end

action :run_query do
  ruby_block 'Executing MySQL query' do
    block do
      DatabaseHelper.execute_query(new_resource.db_query)
    end
  end
end

action :restore_dump do
  execute "Restoring the #{new_resource.db_name} database from #{new_resource.db_dump}" do
    command "mysql -u #{new_resource.db_user} -p#{new_resource.db_password} #{new_resource.db_name} < #{new_resource.db_dump}"
  end
end
