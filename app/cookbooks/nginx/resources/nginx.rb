#
# Cookbook:: nginx
# Resource:: nginx 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :nginx
provides :nginx

property :name,                    String, name_property: true
property :user,                    String, default: node[:nginx][:init][:user]
property :group,                   String, default: node[:nginx][:init][:user]
property :web_root,                String, default: node[:nginx][:init][:web_root]
property :php_version,             String, default: node[:nginx][:php][:version]
property :demo_structure,          Hash
property :ssl_configuration,       Hash
property :configuration,           Hash

action :uninstall do
    apt_package "nginx" do
        action [:remove, :purge]
    end
end

action :install do
    apt_package "nginx" do
        action :install
    end
end

action :configure do
    template "Nginx configuration" do
        source "nginx.conf.erb"
        path "/etc/nginx/nginx.conf"
        owner "root"
        group "root"
        mode "644"
        variables ({ user: "#{new_resource.user}" })
    end
    
    # Remove the default site
    link "/etc/nginx/sites-enabled/default" do
        to "/etc/nginx/sites-available/default"
        action :delete
        only_if { ::File.exist?("/etc/nginx/sites-available/default") }
    end
end

action :create_web_root do
    directory 'Web root directory' do
        path "#{new_resource.web_root}"
        owner "#{new_resource.user}"
        group "#{new_resource.group}"
        mode "0770"
        recursive true
    end
    
    execute "Set setgid on webroot" do
        command "chmod g+s #{new_resource.web_root}"
        only_if { ::File.directory?("#{new_resource.web_root}") }
    end
end

action :clear_sites do
    Dir["/etc/nginx/sites-available/*"].each do |available_site|
        execute "Remove #{available_site}" do
            command "rm -rf #{available_site}"
        end
    end

    Dir["/etc/nginx/sites-enabled/*"].each do |enabled_site|
        execute "Remove #{enabled_site}" do
            command "rm -rf #{enabled_site}"
        end
    end
end

action :configure_multisite do
    directory "Multisite configuration directory" do
        path "/etc/nginx/sites-available/conf"
        owner "root"
        group "root"
        mode "644"
    end
    
    template "Configure Magento and Nginx" do
        source "00-nginx-magento.conf.erb"
        path "/etc/nginx/sites-available/conf/00-nginx-magento.conf"
        owner "root"
        group "root"
        mode "644"
    end

    # Collect vhost data
    vhost_data = Array.new
    new_resource.demo_structure.each do |scope, scope_hash|
        scope_hash.each do |code, url|
            demo_data = Hash.new
            if scope == "store_view"
                demo_data[:scope] = scope.gsub("store_view", "store")
            else
                demo_data[:scope] = scope
            end
            demo_data[:code] = code
            demo_data[:url] = url
            vhost_data << demo_data
        end

        template "Configure multisite" do
            source "01-multisite.conf.erb"
            path "/etc/nginx/sites-available/conf/01-multisite.conf"
            owner "root"
            group "root"
            mode "644"
            variables({ 
                fpm_backend: "#{new_resource.configuration[:fpm_backend]}",
                fpm_port: "#{new_resource.configuration[:fpm_port]}",
                vhost_data: vhost_data
            })
        end
    end

    # Create vhosts and enable them
    vhost_data.each do |vhost|
        template "#{vhost[:url]}" do
            source "vhost.erb"
            path "/etc/nginx/sites-available/#{vhost[:url]}"
            mode "644"
            owner "root"
            group "root"
            variables({
                http_port: "#{new_resource.configuration[:http_port]}",
                ssl_port: "#{new_resource.ssl_configuration[:ssl_port]}",
                server_name: "#{vhost[:url]}",
                client_max_body_size: "#{new_resource.configuration[:client_max_body_size]}",
                web_root: "#{new_resource.web_root}",
                key_directory: "#{new_resource.ssl_configuration[:key_directory]}",
                key_file: "#{new_resource.ssl_configuration[:key_file]}",
                cert_directory: "#{new_resource.ssl_configuration[:cert_directory]}",
                cert_file: "#{new_resource.ssl_configuration[:cert_file]}"
            })
        end

        link "/etc/nginx/sites-enabled/#{vhost[:url]}" do
            to "/etc/nginx/sites-available/#{vhost[:url]}"
            owner "root"
            group "root"
            only_if { ::File.exist?("/etc/nginx/sites-available/#{vhost[:url]}") }
        end
    end
end

action :enable_multisite do
    link "/etc/nginx/sites-enabled/01-multisite.conf" do
        to "/etc/nginx/sites-available/conf/01-multisite.conf"
        owner "root"
        group "root"
    end
end

action :enable do
    service "nginx" do
        action :enable
    end
end

action :restart do
    service "nginx" do
        action :restart
    end
end