#
# Cookbook:: magento
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
web_root = node[:application][:webserver][:web_root]
user = node[:application][:user]
group = node[:application][:group]
db_host = node[:infrastructure][:database][:host]
db_name = node[:infrastructure][:database][:name]
db_user = node[:infrastructure][:database][:user]
db_password = node[:infrastructure][:database][:password]
backend_frontname = node[:application][:installation][:settings][:backend_frontname]
unsecure_base_url = "http://#{node[:fqdn]}/"
secure_base_url = "https://#{node[:fqdn]}/" 
language = node[:application][:installation][:settings][:language]
timezone = node[:infrastructure][:php][:timezone]
currency = node[:application][:installation][:settings][:currency]
admin_firstname = node[:application][:installation][:settings][:admin_firstname]
admin_lastname = node[:application][:installation][:settings][:admin_lastname]
admin_email = node[:application][:installation][:settings][:admin_email]
admin_user = node[:application][:installation][:settings][:admin_user]
admin_password = node[:application][:installation][:settings][:admin_password]
use_rewrites = node[:application][:installation][:settings][:use_rewrites]
use_rewrites ? use_rewrites = 1 : use_rewrites = 0
use_secure_frontend = node[:application][:installation][:settings][:use_secure_frontend]
use_secure_frontend ? use_secure_frontend = 1 : use_secure_frontend = 0
use_secure_admin = node[:application][:installation][:settings][:use_secure_admin]
use_secure_admin ? use_secure_admin = 1 : use_secure_admin = 0
cleanup_database = node[:application][:installation][:settings][:cleanup_database]
session_save = node[:application][:installation][:settings][:session_save]

# Base install string
base_install_string = "--db-host=#{db_host} --db-name=#{db_name} --db-user=#{db_user} --db-password=#{db_password} --backend-frontname=#{backend_frontname} --base-url=#{unsecure_base_url} --language=#{language} --timezone=#{timezone} --currency=#{currency} --admin-firstname=#{admin_firstname} --admin-lastname=#{admin_lastname} --admin-email=#{admin_email} --admin-user=#{admin_user} --admin-password=#{admin_password}"

# Install options
rewrites_string = "--use-rewrites=#{use_rewrites}"
use_secure_frontend_string = "--use-secure=#{use_secure_frontend}"
use_secure_admin_string = "--use-secure-admin=#{use_secure_admin}"
secure_url_string = "--base-url-secure=#{secure_base_url}"
cleanup_database_string = "--cleanup-database"
session_save_string = "--session-save=#{session_save}"

# Create the master install string
install_string = base_install_string + " #{rewrites_string}" if use_rewrites
install_string = install_string + " #{use_secure_admin_string}" if use_secure_admin
install_string = install_string + " #{use_secure_frontend_string}" if use_secure_frontend
install_string = install_string + " #{secure_url_string}" if use_secure_frontend || use_secure_admin
install_string = install_string + " #{cleanup_database_string} #{session_save_string}"

execute "Install Magento" do
    command "cd #{web_root} && su #{user} -c './bin/magento setup:install #{install_string}'"
end
