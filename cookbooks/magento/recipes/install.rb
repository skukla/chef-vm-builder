#
# Cookbook:: magento
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento][:user]
group = node[:magento][:user]
web_root = node[:magento][:web_root]
db_host = node[:magento][:database][:host]
db_user = node[:magento][:database][:user]
db_password = node[:magento][:database][:password]
db_name = node[:magento][:database][:name]
backend_frontname = node[:magento][:installation][:settings][:backend_frontname]
unsecure_base_url = node[:magento][:installation][:settings][:unsecure_base_url]
secure_base_url = node[:magento][:installation][:settings][:secure_base_url]
language = node[:magento][:installation][:settings][:language]
timezone = node[:magento][:installation][:settings][:timezone]
currency = node[:magento][:installation][:settings][:currency]
admin_firstname = node[:magento][:installation][:settings][:admin_firstname]
admin_lastname = node[:magento][:installation][:settings][:admin_lastname]
admin_email = node[:magento][:installation][:settings][:admin_email]
admin_user = node[:magento][:installation][:settings][:admin_user]
admin_password = node[:magento][:installation][:settings][:admin_password]
use_rewrites = node[:magento][:installation][:settings][:use_rewrites]
use_secure_frontend = node[:magento][:installation][:settings][:use_secure_frontend]
use_secure_admin = node[:magento][:installation][:settings][:use_secure_admin]
cleanup_database = node[:magento][:installation][:settings][:cleanup_database]
session_save = node[:magento][:installation][:settings][:session_save]
encryption_key = node[:magento][:installation][:settings][:encryption_key]
custom_modules = node[:magento][:custom_modules]
use_elasticsearch = node[:magento][:elasticsearch][:use]
elasticsearch_host = node[:magento][:elasticsearch][:host]
elasticsearch_port = node[:magento][:elasticsearch][:port]
elasticsearch_node_name = node[:magento][:elasticsearch][:node_name]

# Base install string
install_string = "--db-host=#{db_host} --db-name=#{db_name} --db-user=#{db_user} --db-password=#{db_password} --backend-frontname=#{backend_frontname} --base-url=#{unsecure_base_url} --language=#{language} --timezone=#{timezone} --currency=#{currency} --admin-firstname=#{admin_firstname} --admin-lastname=#{admin_lastname} --admin-email=#{admin_email} --admin-user=#{admin_user} --admin-password=#{admin_password}"

# Install options
rewrites_string = "--use-rewrites=#{process_value(use_rewrites)}"
use_secure_frontend_string = "--use-secure=#{process_value(use_secure_frontend)}"
use_secure_admin_string = "--use-secure-admin=#{process_value(use_secure_admin)}"
secure_url_string = "--base-url-secure=#{secure_base_url}"
cleanup_database_string = "--cleanup-database"
session_save_string = "--session-save=#{session_save}"
encryption_key_string = "--key=#{encryption_key}"
elasticsearch_string = "--es-hosts=#{elasticsearch_host}:#{elasticsearch_port} --es-enable-ssl=#{use_secure_frontend}"

# Create the master install string
install_string = [install_string, rewrites_string].join(" ") if use_rewrites
install_string = [install_string, use_secure_admin_string].join(" ") if use_secure_admin
install_string = [install_string, use_secure_frontend_string].join(" ") if use_secure_frontend
install_string = [install_string, secure_url_string].join(" ") if use_secure_frontend || use_secure_admin
install_string = [install_string, cleanup_database_string, session_save_string, encryption_key_string].join(" ")
install_string = [install_string, elasticsearch_string].join(" ") if use_elasticsearch

# Create the database
ruby_block "Create the Magento database" do
    block do
        %x[mysql --user=root -e "CREATE DATABASE IF NOT EXISTS #{db_name};"]
    end
    action :create
end

ruby_block "Add permissions for database user" do
    block do
        %x[mysql --user=root -e "GRANT ALL ON #{db_name}.* TO '#{db_user}'@'#{db_host}' IDENTIFIED BY '#{db_password}' WITH GRANT OPTION;"]
    end
    action :create
end

# Install the application
execute "Install Magento" do
    command "su #{user} -c '#{web_root}/bin/magento setup:install #{install_string}'"
end