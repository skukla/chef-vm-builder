#
# Cookbook:: magento
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
db_host = node[:magento][:database][:host]
db_user = node[:magento][:database][:user]
db_password = node[:magento][:database][:password]
db_name = node[:magento][:database][:name]
backend_frontname = node[:magento][:backend_frontname]
unsecure_base_url = node[:magento][:unsecure_base_url]
secure_base_url = node[:magento][:secure_base_url]
language = node[:magento][:language]
timezone = node[:magento][:timezone]
currency = node[:magento][:currency]
admin_firstname = node[:magento][:admin_firstname]
admin_lastname = node[:magento][:admin_lastname]
admin_email = node[:magento][:admin_email]
admin_user = node[:magento][:admin_user]
admin_password = node[:magento][:admin_password]
use_rewrites = node[:magento][:use_rewrites]
use_secure_frontend = node[:magento][:use_secure_frontend]
use_secure_admin = node[:magento][:use_secure_admin]
cleanup_database = node[:magento][:cleanup_database]
session_save = node[:magento][:session_save]

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
install_string = [base_install_string, rewrites_string].join(" ") if use_rewrites
install_string = [install_string, use_secure_admin_string].join(" ") if use_secure_admin
install_string = [install_string, use_secure_frontend_string].join(" ") if use_secure_frontend
install_string = [install_string, secure_url_string].join(" ") if use_secure_frontend || use_secure_admin
install_string = [install_string, cleanup_database_string, session_save_string].join(" ")

execute "Install Magento" do
    command "su #{user} -c '#{web_root}/bin/magento setup:install #{install_string}'"
end
