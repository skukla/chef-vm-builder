#
# Cookbook:: ssl
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
ssl "Manage ssl certificates" do
    action [
        :remove_ssl_files,
        :generate_private_key,
        :generate_certificate,
        :generate_server_configuration_file,
        :generate_certificate_signing_request,
        :generate_server_extension_file,
        :generate_server_certificate,
        :refresh_certificate_list,
        :update_ssl_permissions
    ]
end

ssl "Export certificate" do
    action :export_ssl_certificate
    only_if { Dir.exist?("/vagrant/certificate") }
end