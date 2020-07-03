#
# Cookbook:: ssl
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
cert_file = "#{node[:fqdn]}.crt"
key_file = "#{node[:fqdn]}.key"
common_name = node[:fqdn]
keys_directory = node[:ssl][:key_directory]
certs_directory = node[:ssl][:cert_directory]
country = node[:ssl][:country]
region = node[:ssl][:region]
locality = node[:ssl][:locality]
organization = node[:ssl][:organization]

ssl "Remove ssl certificates" do
    action :remove_certificates
    configuration({
        certs_directory: "#{certs_directory}",
        cert_file: "#{cert_file}"
    })
end

ssl "Generate ssl certificates" do
    action :generate_certificate
    configuration({
        country: "#{country}",
        region: "#{region}",
        locality: "#{locality}",
        organization: "#{organization}",
        common_name: "#{common_name}",
        keys_directory: "#{keys_directory}",
        key_file: "#{key_file}",
        certs_directory: "#{certs_directory}",
        cert_file: "#{cert_file}"
    })
    not_if { 
        ::File.exist?("#{certs_directory}/#{cert_file}") && 
        ::File.exist?("#{keys_directory}/#{key_file}") 
        }
end

ssl "Refresh ssl certificates" do
    action :refresh_certificate_list
    not_if { 
        ::File.exist?("#{certs_directory}/#{cert_file}") && 
        ::File.exist?("#{keys_directory}/#{key_file}") 
    }
end