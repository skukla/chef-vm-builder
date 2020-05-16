#
# Cookbook:: magento_configuration
# Recipe:: configure_admin_users
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:magento_configuration][:user]
web_root = node[:magento_configuration][:web_root]
admin_users = node[:magento_configuration][:admin_users]

unless admin_users.nil?
    admin_users.each do |field, value|
        execute "Configuring admin user : #{value[:first_name]} #{value[:last_name]}" do
            command "cd #{web_root} && su #{user} -c './bin/magento admin:user:create --admin-user=#{value[:username]} --admin-password=#{value[:password]} --admin-email=#{value[:email]} --admin-firstname=#{value[:first_name]} --admin-lastname=#{value[:last_name]}'"
        end
    end
end