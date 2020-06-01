#
# Cookbook:: nginx
# Recipe:: ssl
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:nginx][:user]
group = node[:nginx][:user]
keys_directory = node[:nginx][:ssl_key_directory]
key_file = "#{node[:fqdn]}.key"
certs_directory = node[:nginx][:ssl_cert_directory]
cert_file = "#{node[:fqdn]}.crt"
common_name = node[:fqdn]
country = node[:nginx][:ssl_country]
region = node[:nginx][:ssl_region]
locality = node[:nginx][:ssl_locality]
organization = node[:nginx][:ssl_organization]

Dir["#{certs_directory}/*"].each do |old_file|
    if "#{old_file}" != "#{certs_directory}/#{cert_file}"
        execute "Remove old ssl certificates" do
            command "sudo rm -rf #{old_file}"
        end
    end
end

# Generate the ssl key from the conf file
execute "Generate ssl certificate" do
    command "sudo openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj \"/C=#{country}/ST=#{region}/L=#{locality}/O=#{organization}   /CN=#{common_name}\" \
    -keyout #{keys_directory}/#{key_file} -out #{certs_directory}/#{cert_file}"
    not_if { ::File.exist?("#{certs_directory}/#{cert_file}") && ::File.exist?("#{keys_directory}/#{key_file}") }
end

# Refresh the certs bundle
execute "Refresh the certs list" do
    command "sudo update-ca-certificates --fresh"
    not_if { ::File.exist?("#{certs_directory}/#{cert_file}") && ::File.exist?("#{keys_directory}/#{key_file}") }
end
