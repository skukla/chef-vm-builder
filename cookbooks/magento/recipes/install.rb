#
# Cookbook:: magento
# Recipe:: install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
web_root = node[:magento][:installation][:options][:directory]
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

def process_value(user_value)
    if user_value == true
        return 1
    elsif user_value == false
        return 0
    else
        return user_value
    end
end

# Base install string
base_install_string = "--db-host=#{db_host} --db-name=#{db_name} --db-user=#{db_user} --db-password=#{db_password} --backend-frontname=#{backend_frontname} --base-url=#{unsecure_base_url} --language=#{language} --timezone=#{timezone} --currency=#{currency} --admin-firstname=#{admin_firstname} --admin-lastname=#{admin_lastname} --admin-email=#{admin_email} --admin-user=#{admin_user} --admin-password=#{admin_password}"

# Install options
rewrites_string = "--use-rewrites=#{process_value(use_rewrites)}"
use_secure_frontend_string = "--use-secure=#{process_value(use_secure_frontend)}"
use_secure_admin_string = "--use-secure-admin=#{process_value(use_secure_admin)}"
secure_url_string = "--base-url-secure=#{secure_base_url}"
cleanup_database_string = "--cleanup-database"
session_save_string = "--session-save=#{session_save}"

# Create the master install string
install_string = [base_install_string, rewrites_string].join(" ") if use_rewrites
install_string = [install_string, use_secure_admin_string].join(" ") if use_secure_admin
install_string = [install_string, use_secure_frontend_string].join(" ") if use_secure_frontend
install_string = [install_string, secure_url_string].join(" ") if use_secure_frontend || use_secure_admin
install_string = [base_install_string, install_string, cleanup_database_string, session_save_string].join(" ")

execute "Install Magento" do
    command "su #{user} -c '#{web_root}/bin/magento setup:install #{install_string}'"
end
