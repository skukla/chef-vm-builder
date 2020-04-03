#
# Cookbook:: magento
# Recipe:: configure-nginx
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:application][:user]
group = node[:application][:group]
web_root = node[:application][:webserver][:web_root]
php_version = node[:infrastructure][:php][:version]
custom_demo_data = node[:custom_demo][:verticals]
certificate_file = node[:infrastructure][:webserver][:ssl_files][:certificate_file]
key_file = node[:infrastructure][:webserver][:ssl_files][:key_file]
fpm_backend = node[:infrastructure][:webserver][:fpm_backend]
fpm_port = node[:infrastructure][:php][:fpm_port]
web_root = node[:infrastructure][:webserver][:conf_options][:web_root]
client_max_body_size = node[:infrastructure][:webserver][:conf_options][:client_max_body_size]
http_port = node[:infrastructure][:webserver][:http_port]
ssl_port = node[:infrastructure][:webserver][:ssl_port]

# Extract the data for the virtual host files
selected_vertical_data = Array.new
custom_demo_data.each do |vertical_key, vertical_value|
    vertical_value.each do |channel_key, channel_value|
        next unless vertical_value[channel_key][:use]
        selected_vertical_geos = Array.new
        selected_vertical_collection = Hash.new
        selected_vertical_collection[:vertical] = vertical_key
        selected_vertical_collection[:channel] = channel_key
        selected_vertical_collection[:url] = vertical_value[channel_key][:url]
        selected_vertical_collection[:scope] = vertical_value[channel_key][:scope]
        selected_vertical_collection[:code] = vertical_value[channel_key][:code]
        vertical_value[channel_key][:geos].each do |selected_geo_key, selected_geo_value|
            next unless selected_geo_value
            selected_vertical_geos << selected_geo_key
        end
        selected_vertical_collection[:geos] = selected_vertical_geos
        selected_vertical_data << selected_vertical_collection
    end
end

# Configure the virtual hosts
selected_vertical_data.each do |selected_vertical|
    # Disable any of the sites if they already exist
    link "/etc/nginx/sites-enabled/#{selected_vertical[:vertical]}_#{selected_vertical[:channel]}" do
        to "/etc/nginx/sites-available/#{selected_vertical[:vertical]}_#{selected_vertical[:channel]}"
        action :delete
        only_if { ::File.exists?("/etc/nginx/sites-available/#{selected_vertical[:vertical]}_#{selected_vertical[:channel]}") }
    end
    # Create the virtual hosts
    template "#{selected_vertical[:vertical]}_#{selected_vertical[:channel]}" do
        source "#{selected_vertical[:vertical]}_#{selected_vertical[:channel]}.erb"
        path "/etc/nginx/sites-available/#{selected_vertical[:vertical]}_#{selected_vertical[:channel]}"
        mode '644'
        owner 'root'
        group 'root'
        variables({
            http_port: "#{http_port}",
            ssl_port: "#{ssl_port}",
            server_name: "#{selected_vertical[:url]}",
            client_max_body_size: "#{client_max_body_size}",
            web_root: "#{web_root}",
            key_file: "#{key_file}",
            certificate_file: "#{certificate_file}"
        })
    end
    # Enable the selected sites
    link "/etc/nginx/sites-enabled/#{selected_vertical[:vertical]}_#{selected_vertical[:channel]}" do
        to "/etc/nginx/sites-available/#{selected_vertical[:vertical]}_#{selected_vertical[:channel]}"
        owner 'root'
        group 'root'
        only_if { ::File.exists?("/etc/nginx/sites-available/#{selected_vertical[:vertical]}_#{selected_vertical[:channel]}") }
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
        vhost_data: selected_vertical_data
    })
    only_if { ::File.directory?('/etc/nginx/sites-available/conf') }
end

# Enable the multisite configuration
link '/etc/nginx/sites-enabled/01-multisite.conf' do
    to '/etc/nginx/sites-available/conf/01-multisite.conf'
    owner 'root'
    group 'root'
    only_if { ::File.exists?('/etc/nginx/sites-available/conf/01-multisite.conf') }
    notifies :restart, 'service[nginx]', :immediately
end

# Restart PHP
service "php#{php_version}-fpm" do
    action :restart
end
