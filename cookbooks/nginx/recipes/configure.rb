#
# Cookbook:: nginx
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
fpm_backend = node[:infrastructure][:php][:fpm_options][:backend]
fpm_port = node[:infrastructure][:php][:fpm_options][:port]
webroot = node[:infrastructure][:webserver][:webroot]
client_max_body_size = node[:infrastructure][:webserver][:client_max_body_size]
http_port = node[:infrastructure][:webserver][:http_port]
ssl_port = node[:infrastructure][:webserver][:ssl_port]
key_file = node[:infrastructure][:webserver][:ssl_files][:key_file]
certificate_file = node[:infrastructure][:webserver][:ssl_files][:certificate_file]
user = node[:infrastructure][:webserver][:vm][:user]
group = node[:infrastructure][:webserver][:vm][:group]
custom_demo_verticals = node[:custom_demo][:verticals]
custom_demo_channels = node[:custom_demo][:channels]
customm_demo_geos = node[:custom_demo][:geos]
application_verticals = node[:infrastructure][:webserver][:application][:verticals]

# Create the web root
directory 'Webroot directory' do
    path "#{webroot}"
    owner "#{user}"
    group "#{group}"
    mode '755'
    not_if { ::File.directory?("#{webroot}") }
end

# Configure nginx
template 'Nginx configuration' do
    path '/etc/nginx/nginx.conf'
    source 'nginx.conf.erb'
    owner 'root'
    group 'root'
    mode '644'
    variables ({ user: user })
    only_if { ::File.exists?('/etc/nginx/nginx.conf') }
end

# Extract the data for the virtual host files
selected_vertical_data = Array.new
custom_demo_verticals.each do |vertical_name, vertical_choice|
    next unless vertical_choice
    custom_demo_channels.each do |channel_name, channel_choice|
        next unless channel_choice
        vertical_data = application_verticals[vertical_name]
        customm_demo_geos.each do |geo|
            selected_vertical_collection = Hash.new
            channel_value = vertical_data[geo][channel_name]
            selected_vertical_collection[:geo] = geo
            selected_vertical_collection[:scope] = channel_value[:scope]
            selected_vertical_collection[:url] = channel_value[:url]
            selected_vertical_collection[:code] = channel_value[:code]
            selected_vertical_data << selected_vertical_collection
        end
    end
end

# Remove the default site
link '/etc/nginx/sites-enabled/default' do
    to '/etc/nginx/sites-available/default'
    action :delete
    only_if { ::File.exists?('/etc/nginx/sites-available/default') }
end

# Configure the virtual hosts   
selected_vertical_data.each do |selected_vertical|
    # Disable any of the sites if they already exist
    link "/etc/nginx/sites-enabled/#{selected_vertical[:url]}" do
        to "/etc/nginx/sites-available/#{selected_vertical[:url]}"
        action :delete
        only_if { ::File.exists?("/etc/nginx/sites-available/#{selected_vertical[:url]}") }
    end
    # Create the virtual hosts
    template "#{selected_vertical[:url]}" do
        path "/etc/nginx/sites-available/#{selected_vertical[:url]}"
        source "#{selected_vertical[:url]}.erb"
        mode '644'
        owner 'root'
        group 'root'
        variables({
            http_port: http_port,
            ssl_port: ssl_port,
            server_name: "#{selected_vertical[:url]}",
            client_max_body_size: client_max_body_size,
            webroot: webroot,
            key_file: key_file,
            certificate_file: certificate_file
        })
    end
    # Enable the selected sites
    link "/etc/nginx/sites-enabled/#{selected_vertical[:url]}" do
        to "/etc/nginx/sites-available/#{selected_vertical[:url]}"
        owner 'root'
        group 'root'
        only_if { ::File.exists?("/etc/nginx/sites-available/#{selected_vertical[:url]}") }
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

# Configure multisite
template 'Configure multisite' do
    path '/etc/nginx/sites-available/conf/01-multisite.conf'
    source '01-multisite.conf.erb'
    owner 'root'
    group 'root'
    mode '644'
    variables({ 
        fpm_backend: fpm_backend,
        fpm_port: fpm_port,
        vhost_data: selected_vertical_data 
    })
    only_if { ::File.directory?('/etc/nginx/sites-available/conf') }
end

# Define, enable, and start the nginx service
service 'nginx' do
    action [:enable, :start]
end
