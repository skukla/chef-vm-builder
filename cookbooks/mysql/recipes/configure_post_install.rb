#
# Cookbook:: mysql
# Recipe:: configure_pre_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
post_install_settings = node[:infrastructure][:database][:post_install_settings]

post_install_settings = [
    'log_bin_trust_function_creators',
    'autocommit',
    'unique_checks',
    'foreign_key_checks' 
]

# Configure post-install settings
post_install_settings.each do |setting, value|
    ruby_block "Configure MySQL post-install setting : #{setting}" do
        block do
            "%x[mysql -uroot -e \"SET GLOBAL #{setting} = #{value};\"]"
        end
        action :create
    end
end

# Restart MySQL
service 'mysql' do
    action :restart
end