#
# Cookbook:: nginx
# Recipe:: install_ssl
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:infrastructure][:webserver][:vm][:user]
group = node[:infrastructure][:webserver][:vm][:group]
ssl_options = node[:infrastructure][:webserver][:ssl_options]
ssl_files = node[:infrastructure][:webserver][:ssl_files]

# Generate the ssl key from the conf file
execute 'Generate ssl key' do
    command "openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj \"/C=#{ssl_options[:country]}/ST=#{ssl_options[:state]}/L=#{ssl_options[:locality]}/O=#{ssl_options[:organization]}   /CN=#{node[:fqdn]}\" \
    -keyout /home/#{user}/#{ssl_files[:key_file]}  -out /home/#{user}/#{ssl_files[:certificate_file]}"
    not_if { ::File.exists?("/etc/ssl/certs/#{ssl_files[:certificate_file]}") }
end

# Copy the certificate to the ssl certs directory, then delete the original
execute 'Copy SSL certificate to the certs directory' do
    command "sudo cp /home/#{user}/#{ssl_files[:certificate_file]} /etc/ssl/certs/#{ssl_files[:certificate_file]} && sudo rm -rf /home/#{user}/#{ssl_files[:certificate_file]}"
    only_if { ::File.exists?("/home/#{user}/#{ssl_files[:certificate_file]}") }
end

# Copy the SSL key to the private directory, then delete the original
execute 'Copy SSL key to the private directory' do
    command "sudo cp /home/#{user}/#{ssl_files[:key_file]} /etc/ssl/private/#{ssl_files[:default_key_f]} && sudo rm -rf /home/#{user}/#{ssl_files[:key_file]}"
    only_if { ::File.exists?("/home/#{user}/#{ssl_files[:key_file]}") }
end
