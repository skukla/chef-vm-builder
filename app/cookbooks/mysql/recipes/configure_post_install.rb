#
# Cookbook:: mysql
# Recipe:: configure_pre_install
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
install_settings = node[:mysql][:install_settings]

# Configure post-install settings
install_settings.each do |setting|
    next if setting == "log_bin_trust_function_creators"
    ruby_block "Configure MySQL post-install setting : #{setting}" do
        block do
            "%x[mysql -uroot -e \"SET GLOBAL #{setting} = 1;\"]"
        end
        action :create
    end
end

# Restart MySQL
service 'mysql' do
    action :restart
end