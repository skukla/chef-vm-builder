#
# Cookbook:: nginx
# Recipe:: install_ssl
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
user = node[:remote_machine][:user]
group = node[:remote_machine][:user]
common_name = node[:fqdn]
country = node[:infrastructure][:webserver][:ssl_options][:country]
state = node[:infrastructure][:webserver][:ssl_options][:state]
locality = node[:infrastructure][:webserver][:ssl_options][:locality]
organization = node[:infrastructure][:webserver][:ssl_options][:organization]
key_file = node[:infrastructure][:webserver][:ssl_files][:key_file]
certificate_file = node[:infrastructure][:webserver][:ssl_files][:certificate_file]

# Generate the ssl key from the conf file
execute 'Generate ssl key' do
    command "sudo openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj \"/C=#{country}/ST=#{state}/L=#{locality}/O=#{organization}   /CN=#{common_name}\" \
    -keyout /home/#{user}/#{key_file}  -out /home/#{user}/#{certificate_file}"
    not_if { ::File.exists?("/etc/ssl/certs/#{certificate_file}") }
end

# Copy the certificate to the ssl certs directory, then delete the original
execute 'Copy SSL certificate to the certs directory' do
    command "sudo cp /home/#{user}/#{certificate_file} /etc/ssl/certs/#{certificate_file} && sudo rm -rf /home/#{user}/#{certificate_file}"
    only_if { ::File.exists?("/home/#{user}/#{certificate_file}") }
end

# Copy the SSL key to the private directory, then delete the original
execute 'Copy SSL key to the private directory' do
    command "sudo cp /home/#{user}/#{key_file} /etc/ssl/private/#{key_file} && sudo rm -rf /home/#{user}/#{key_file}"
    only_if { ::File.exists?("/home/#{user}/#{key_file}") }
end
