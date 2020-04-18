#
# Cookbook:: app_configuration
# Recipe:: configure_admin_users
#
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
configure_admin_users_flag = node[:application][:installation][:options][:configuration][:admin_users]
admin_users = node[:custom_demo][:admin_users]

# Configure admin users according to settings
if configure_admin_users_flag
    admin_users.each do |user_key, user_value|
        if user_value[:enable]
            execute "Configuring admin user : #{user_value[:first_name]} #{user_value[:last_name]}" do
                command "cd #{web_root} && su #{user} -c './bin/magento admin:user:create --admin-user=#{user_value[:username]} --admin-password=#{user_value[:password]} --admin-email=#{user_value[:email]} --admin-firstname=#{user_value[:first_name]} --admin-lastname=#{user_value[:last_name]}'"
            end
        end
    end
end
