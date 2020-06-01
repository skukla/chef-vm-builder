#
# Cookbook:: nginx
# Recipe:: configure_multisite
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:nginx][:user]
group = node[:nginx][:user]
web_root = node[:nginx][:web_root]
php_version = node[:nginx][:php_version]
fpm_backend = node[:nginx][:fpm_backend]
fpm_port = node[:nginx][:fpm_port]
client_max_body_size = node[:nginx][:client_max_body_size]
http_port = node[:nginx][:http_port]
ssl_port = node[:nginx][:ssl_port]
cert_directory = node[:nginx][:ssl_cert_directory]
cert_file = "#{node[:fqdn]}.crt"
key_directory = node[:nginx][:ssl_key_directory]
key_file = "#{node[:fqdn]}.key"
custom_demo_structure = node[:nginx][:structure]

# Extract the data for the virtual host files
vhost_data = Array.new
custom_demo_structure.each do |scope, scope_hash|
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
end

# Clear all sites in sites-available
Dir["/etc/nginx/sites-available/*"].each do |available_site|
    execute "Remove #{available_site}" do
        command "sudo rm -rf #{available_site}"
    end
end

# Clear all sites in sites-enabled
Dir["/etc/nginx/sites-enabled/*"].each do |enabled_site|
    execute "Remove #{enabled_site}" do
        command "sudo rm -rf #{enabled_site}"
    end
end

# Create the virtual hosts
vhost_data.each do |vhost|
    template "#{vhost[:url]}" do
        source "vhost.erb"
        path "/etc/nginx/sites-available/#{vhost[:url]}"
        mode '644'
        owner 'root'
        group 'root'
        variables({
            http_port: "#{http_port}",
            ssl_port: "#{ssl_port}",
            server_name: "#{vhost[:url]}",
            client_max_body_size: "#{client_max_body_size}",
            web_root: "#{web_root}",
            key_directory: "#{key_directory}",
            key_file: "#{key_file}",
            cert_directory: "#{cert_directory}",
            cert_file: "#{cert_file}"
        })
    end
    # Enable the selected sites
    link "/etc/nginx/sites-enabled/#{vhost[:url]}" do
        to "/etc/nginx/sites-available/#{vhost[:url]}"
        owner 'root'
        group 'root'
        only_if { ::File.exist?("/etc/nginx/sites-available/#{vhost[:url]}") }
    end
end

# Create the conf directory for multisite
directory 'Multisite configuration directory' do
    path '/etc/nginx/sites-available/conf'
    owner 'root'
    group 'root'
    mode '644'
    only_if { ::File.directory?('/etc/nginx/sites-available') }
end

# Configure Magento and Nginx
template 'Configure Magento and Nginx' do
    source '00-nginx-magento.conf.erb'
    path '/etc/nginx/sites-available/conf/00-nginx-magento.conf'
    owner 'root'
    group 'root'
    mode '644'
    only_if { ::File.directory?('/etc/nginx/sites-available/conf') }
end

# Configure multisite
template 'Configure multisite' do
    source '01-multisite.conf.erb'
    path '/etc/nginx/sites-available/conf/01-multisite.conf'
    owner 'root'
    group 'root'
    mode '644'
    variables({ 
        fpm_backend: "#{fpm_backend}",
        fpm_port: "#{fpm_port}",
        vhost_data: vhost_data
    })
    only_if { ::File.directory?('/etc/nginx/sites-available/conf') }
end

# Enable the multisite configuration
link '/etc/nginx/sites-enabled/01-multisite.conf' do
    to '/etc/nginx/sites-available/conf/01-multisite.conf'
    owner 'root'
    group 'root'
    only_if { ::File.exist?('/etc/nginx/sites-available/conf/01-multisite.conf') }
    notifies :restart, 'service[nginx]', :immediately
end

# Restart PHP
service "php#{php_version}-fpm" do
    action :restart
end