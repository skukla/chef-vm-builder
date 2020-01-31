#
# Cookbook:: nginx
# Recipe:: configure
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
webroot = node[:infrastructure][:webserver][:webroot]
client_max_body_size = node[:infrastructure][:webserver][:client_max_body_size]
port = node[:infrastructure][:webserver][:port]
user = node[:infrastructure][:webserver][:vm][:user]
group = node[:infrastructure][:webserver][:vm][:group]
custom_demo_verticals = node[:custom_demo][:verticals]
custom_demo_channels = node[:custom_demo][:channels]
customm_demo_geos = node[:custom_demo][:geos]
application_verticals = node[:infrastructure][:webserver][:application][:verticals]

# Create the web root
directory 'Webroot directorys' do
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
data = Array.new
collection = Hash.new
custom_demo_verticals.each do |vertical_name, vertical_choice|
    next unless vertical_choice
    custom_demo_channels.each do |channel_name, channel_choice|
        next unless channel_choice
        vertical_data = application_verticals[vertical_name]
        customm_demo_geos.each do |geo|
            channel_value = vertical_data[geo][channel_name]
            collection[:geo] = geo
            collection[:url] = channel_value[:url]
            collection[:code] = channel_value[:code]
            data << collection
        end
    end
end

# Configure the virtual hosts


# Enable sites


# Configure multisite


# Define the nginx service
# service 'nginx' do
#     action [:enable, :start]
# end
