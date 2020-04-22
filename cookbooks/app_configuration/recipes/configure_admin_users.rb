#
# Cookbook:: app_configuration
# Recipe:: configure_admin_users
#
# 
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
web_root = node[:application][:installation][:options][:directory]
custom_demo_data = node[:custom_demo]
admin_users = custom_demo_data[:admin_users]

# Configure admin users according to settings
if custom_demo_data.has_key?(:admin_users)
    admin_users.each do |field, value|
        execute "Configuring admin user : #{value[:first_name]} #{value[:last_name]}" do
            command "cd #{web_root} && su #{user} -c './bin/magento admin:user:create --admin-user=#{value[:username]} --admin-password=#{value[:password]} --admin-email=#{value[:email]} --admin-firstname=#{value[:first_name]} --admin-lastname=#{value[:last_name]}'"
        end
    end
end