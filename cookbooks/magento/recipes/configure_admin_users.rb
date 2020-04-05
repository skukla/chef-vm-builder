#
# Cookbook:: magento
# Recipe:: configure_admin_users
#
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:vm][:user]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
composer_install_dir = node[:application][:composer][:install_dir]
composer_file = node[:application][:composer][:filename]
apply_base_flag = node[:application][:installation][:options][:configuration][:base]
admin_users = node[:custom_demo][:configuration][:admin_users]

# Configure base application according to settings
if apply_base_flag
    # Admin users (Magento CLI, not config:set)
    admin_users.each do |user_key, user_value|
        if user_value[:enable]
            execute "Configuring admin user : #{user_value[:first_name]} #{user_value[:last_name]}" do
                command "cd #{web_root} && su #{user} -c './bin/magento admin:user:create --admin-user=#{user_value[:username]} --admin-password=#{user_value[:password]} --admin-email=#{user_value[:email]} --admin-firstname=#{user_value[:first_name]} --admin-lastname=#{user_value[:last_name]}'"
            end
        end
    end
end
