#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
webserver_type = node[:apache][:init][:webserver_type]

if webserver_type == "apache2"
    apache "Install Apache" do
        action :install
    end

    apache "Create web root and clear existing sites" do
        action [:create_web_root, :clear_sites]
    end

    ssl "Update SSL directory permissions" do
        action :update_ssl_permissions
    end

    apache "Configure Apache" do
        action [:configure_apache, :configure_ports, :configure_ssl, :configure_php_fpm, :configure_multisite]
    end

    apache "Change user and group, enable, and restart Apache" do
        action [:set_permissions, :enable, :restart]
    end

    php "Restart PHP" do
        action :restart
    end
end