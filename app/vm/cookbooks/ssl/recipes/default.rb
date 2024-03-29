#
# Cookbook:: ssl
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
magento_ssl_frontend = node[:ssl][:magento][:settings][:use_secure_frontend]
magento_ssl_admin = node[:ssl][:magento][:settings][:use_secure_admin]

ssl 'Manage ssl certificates' do
  action %i[
    remove_ssl_files
    generate_private_key
    generate_certificate
    generate_server_configuration_file
    generate_certificate_signing_request
    generate_server_extension_file
    generate_server_certificate
    refresh_certificate_list
    update_ssl_permissions
  ]
  only_if { magento_ssl_frontend == 1 || magento_ssl_admin == 1 }
end

ssl 'Export certificate' do
  action :export_ssl_certificate
  only_if do
    Dir.exist?('/vagrant/certificate') &&
      magento_ssl_frontend == 1 || magento_ssl_admin == 1
  end
end
