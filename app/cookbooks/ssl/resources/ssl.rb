#
# Cookbook:: ssl
# Resource:: ssl 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :ssl
provides :ssl

property :name,               String, name_property: true
property :user,               String, default: node[:ssl][:init][:user]
property :group,              String, default: node[:ssl][:init][:user]
property :chainfile,          String, default: node[:ssl][:chainfile]
property :cert_file,          String, default: "#{node[:fqdn]}.crt"
property :key_file,           String, default: "#{node[:fqdn]}.key"
property :key_directory,     String, default: node[:ssl][:key_directory]
property :cert_directory,    String, default: node[:ssl][:cert_directory]
property :common_name,        String, default: node[:fqdn]
property :country,            String, default: node[:ssl][:country]
property :region,             String, default: node[:ssl][:region]
property :locality,           String, default: node[:ssl][:locality]
property :organization,       String, default: node[:ssl][:organization]

action :remove_certificates do
    Dir["#{new_resource.cert_directory}/*"].each do |old_file|
        execute "Remove old ssl certificates" do
            command "rm -rf #{old_file}"
            only_if { old_file != "#{new_resource.cert_directory}/#{new_resource.cert_file}" }
        end
    end
end

action :generate_certificate do
    execute "Generate ssl certificate" do
        command "openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
        -subj \"/C=#{new_resource.country}/ST=#{new_resource.region}/L=#{new_resource.locality}/O=#{new_resource.organization}/CN=#{new_resource.common_name}\" \
        -keyout #{new_resource.key_directory}/#{new_resource.key_file} -out #{new_resource.cert_directory}/#{new_resource.cert_file}"
        not_if { 
            ::File.exist?("#{new_resource.cert_directory}/#{new_resource.cert_file}") && 
            ::File.exist?("#{new_resource.key_directory}/#{new_resource.key_file}") 
        }
    end

    execute "Copy chainfile to certs directory" do
        command "cp /etc/ssl/certs/#{new_resource.chainfile} #{new_resource.cert_directory}"
        only_if { ::File.exist?("/etc/ssl/certs/#{new_resource.chainfile}") }
    end
end

action :refresh_certificate_list do
    execute "Refresh the certifcate list" do
        command "update-ca-certificates --fresh"
    end
end

action :update_ssl_permissions do
    [new_resource.cert_directory, new_resource.key_directory].each do |directory|
        execute "Set the VM user as the ssl owner" do
            command "chown -R #{new_resource.user}:#{new_resource.group} #{directory}"
            only_if { ::Dir.exist?(directory) }
        end
    end

    execute "Update key directory permissions" do
        command "chmod 775 #{new_resource.key_directory}"
        only_if { ::File.exist?("#{new_resource.key_directory}/#{new_resource.key_file}")  }
    end

    execute "Update key file permissions" do
        command "chmod 640 #{new_resource.key_directory}/#{new_resource.key_file}"
        only_if { ::File.exist?("#{new_resource.key_directory}/#{new_resource.key_file}")  }
    end
end