#
# Cookbook:: ssl
# Resource:: ssl 
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :ssl
provides :ssl

property :name,                     String, name_property: true
property :user,                     String, default: node[:cli][:user]
property :group,                    String, default: node[:cli][:user]
property :web_root,                 String, default: node[:cli][:nginx][:web_root]
property :configuration,            Hash

action :remove_certificates do
    Dir["#{new_resource.configuration[:certs_directory]}/*"].each do |old_file|
        if "#{old_file}" != "#{new_resource.configuration[:certs_directory]}/#{new_resource.configuration[:cert_file]}"
            execute "Remove old ssl certificates" do
                command "rm -rf #{old_file}"
            end
        end
    end
end

action :generate_certificate do
    execute "Generate ssl certificate" do
        command "openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
        -subj \"/C=#{new_resource.configuration[:country]}/ST=#{new_resource.configuration[:region]}/L=#{new_resource.configuration[:locality]}/O=#{new_resource.configuration[:organization]}/CN=#{new_resource.configuration[:common_name]}\" \
        -keyout #{new_resource.configuration[:keys_directory]}/#{new_resource.configuration[:key_file]} -out #{new_resource.configuration[:certs_directory]}/#{new_resource.configuration[:cert_file]}"
    end
end

action :refresh_certificate_list do
    execute "Refresh the certs list" do
        command "update-ca-certificates --fresh"
    end
end