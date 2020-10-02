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

    apache "Configure Apache" do
        action [
            :configure_apache,
            :configure_ports,
            :configure_fpm_conf,
            :configure_multisite,
            :configure_envvars
        ]
    end

    apache "Change user and group, enable, and restart Apache" do
        action [:set_permissions, :enable, :restart]
    end

    php "Restart PHP" do
        action :restart
    end
end