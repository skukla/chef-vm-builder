#
# Cookbook:: nginx
# Recipe:: ssl
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:nginx][:user]
group = node[:nginx][:user]
key_file = node[:nginx][:ssl_key_file]
certificate_file = node[:nginx][:ssl_certificate_file]
common_name = node[:fqdn]
country = node[:nginx][:ssl_country]
region = node[:nginx][:ssl_region]
locality = node[:nginx][:ssl_locality]
organization = node[:nginx][:ssl_organization]

# Generate the ssl key from the conf file
execute 'Generate ssl key' do
    command "sudo openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj \"/C=#{country}/ST=#{region}/L=#{locality}/O=#{organization}   /CN=#{common_name}\" \
    -keyout /home/#{user}/#{key_file}  -out /home/#{user}/#{certificate_file}"
    not_if { ::File.exist?("/etc/ssl/certs/#{certificate_file}") }
end

# Copy the certificate to the ssl certs directory, then delete the original
execute 'Copy SSL certificate to the certs directory' do
    command "sudo cp /home/#{user}/#{certificate_file} /etc/ssl/certs/#{certificate_file} && sudo rm -rf /home/#{user}/#{certificate_file}"
    only_if { ::File.exist?("/home/#{user}/#{certificate_file}") }
end

# Copy the SSL key to the private directory, then delete the original
execute 'Copy SSL key to the private directory' do
    command "sudo cp /home/#{user}/#{key_file} /etc/ssl/private/#{key_file} && sudo rm -rf /home/#{user}/#{key_file}"
    only_if { ::File.exist?("/home/#{user}/#{key_file}") }
end
