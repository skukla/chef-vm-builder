#
# Cookbook:: nginx
# Recipe:: ssl
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
keys_directory = node[:nginx][:ssl_key_directory]
key_file = "#{node[:fqdn]}.key"
certs_directory = node[:nginx][:ssl_cert_directory]
cert_file = "#{node[:fqdn]}.crt"
common_name = node[:fqdn]
country = node[:nginx][:ssl_country]
region = node[:nginx][:ssl_region]
locality = node[:nginx][:ssl_locality]
organization = node[:nginx][:ssl_organization]

nginx "Remove ssl certificates" do
    action :remove_ssl_certificates
    ssl_configuration({
        certs_directory: certs_directory,
        cert_file: cert_file
    })
end

nginx "Generate ssl certificates" do
    action :generate_ssl_certificate
    ssl_configuration({
        country: country,
        region: region,
        locality: locality,
        organization: organization,
        common_name: common_name,
        keys_directory: keys_directory,
        key_file: key_file,
        certs_directory: certs_directory,
        cert_file: cert_file
    })
    not_if { 
        ::File.exist?("#{certs_directory}/#{cert_file}") && 
        ::File.exist?("#{keys_directory}/#{key_file}") 
        }
end

nginx "Refresh ssl certificates" do
    action :refresh_ssl_certificate_list
    not_if { 
        ::File.exist?("#{certs_directory}/#{cert_file}") && 
        ::File.exist?("#{keys_directory}/#{key_file}") 
    }
end