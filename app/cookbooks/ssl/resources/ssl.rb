#
# Cookbook:: ssl
# Resource:: ssl
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
resource_name :ssl
provides :ssl

property :name,                              String,            name_property: true
property :user,                              String,            default: node[:ssl][:init][:user]
property :group,                             String,            default: node[:ssl][:init][:user]
property :ssl_directory,                     String,            default: node[:ssl][:directory]
property :ca_private_key_file,               String,            default: node[:ssl][:ca_private_key_file]
property :ca_certificate_file,               String,            default: node[:ssl][:ca_certificate_file]
property :ca_serial_file,                    String,            default: node[:ssl][:ca_serial_file]
property :csr_configuration_file,            String,            default: node[:ssl][:csr_configuration_file]
property :csr_file,                          String,            default: node[:ssl][:csr_file]
property :server_private_key_file,           String,            default: node[:ssl][:server_private_key_file]
property :server_extension_file,             String,            default: node[:ssl][:server_extension_file]
property :server_certificate_file,           String,            default: node[:ssl][:server_certificate_file]
property :chainfile,                         String,            default: node[:ssl][:chainfile]
property :key_size,                          [String, Integer], default: node[:ssl][:key_size]
property :certificate_days,                  [String, Integer], default: node[:ssl][:certificate_days]
property :country,                           String,            default: node[:ssl][:country]
property :region,                            String,            default: node[:ssl][:region]
property :locality,                          String,            default: node[:ssl][:locality]
property :organization,                      String,            default: node[:ssl][:organization]
property :organizational_unit,               String,            default: node[:ssl][:organizational_unit]
property :common_name,                       String,            default: node[:ssl][:common_name]

action :remove_local_ssl_certificates do
  execute 'Remove local server certificates' do
    command 'rm -rf /vagrant/certificate/*.crt'
    only_if { ::Dir.exist?('/vagrant/certificate') }
  end
end

action :remove_ssl_files do
  execute 'Remove existing private key files' do
    command "rm -rf #{new_resource.ssl_directory}/#{new_resource.ca_private_key_file}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.ca_private_key_file}") }
  end

  execute 'Remove existing certificate files' do
    command "rm -rf #{new_resource.ssl_directory}/#{new_resource.ca_certificate_file}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.ca_certificate_file}") }
  end

  execute 'Remove existing serial files' do
    command "rm -rf #{new_resource.ssl_directory}/#{new_resource.ca_serial_file}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.ca_serial_file}") }
  end

  execute 'Remove existing CSR configuration files' do
    command "rm -rf #{new_resource.ssl_directory}/#{new_resource.csr_configuration_file}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.csr_configuration_file}") }
  end

  execute 'Remove existing CSR files' do
    command "rm -rf #{new_resource.ssl_directory}/#{new_resource.csr_file}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.csr_file}") }
  end

  execute 'Remove existing server private keys' do
    command "rm -rf #{new_resource.ssl_directory}/#{new_resource.server_private_key_file}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.server_private_key_file}") }
  end

  execute 'Remove existing server extension files' do
    command "rm -rf #{new_resource.ssl_directory}/#{new_resource.server_extension_file}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.server_extension_file}") }
  end

  execute 'Remove existing server certificates' do
    command "rm -rf #{new_resource.ssl_directory}/#{new_resource.server_certificate_file}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.server_certificate_file}") }
  end
end

action :generate_private_key do
  execute 'General ssl private key' do
    command "openssl genrsa -out #{new_resource.ssl_directory}/#{new_resource.ca_private_key_file} #{new_resource.key_size}"
  end
end

action :generate_certificate do
  execute 'Create self-signed CA certificate' do
    command "openssl req -new -x509 -days #{new_resource.certificate_days} -nodes -key #{new_resource.ssl_directory}/#{new_resource.ca_private_key_file} -sha256 -out #{new_resource.ssl_directory}/#{new_resource.ca_certificate_file} -subj \"/C=#{new_resource.country}/ST=#{new_resource.region}/L=#{new_resource.locality}/O=#{new_resource.organization}/OU=#{new_resource.organizational_unit}/CN=#{new_resource.common_name}\""
  end
end

action :generate_server_configuration_file do
  template 'Create server configuration file' do
    source "#{new_resource.csr_configuration_file}.erb"
    path "#{new_resource.ssl_directory}/#{new_resource.csr_configuration_file}"
    owner 'root'
    group 'root'
    mode '755'
    variables({
                key_size: new_resource.key_size,
                country: new_resource.country,
                region: new_resource.region,
                locality: new_resource.locality,
                organization: new_resource.organization,
                organizational_unit: new_resource.organizational_unit,
                email: "admin@#{new_resource.common_name}",
                common_name: new_resource.common_name
              })
  end
end

action :generate_certificate_signing_request do
  execute 'Create certificate signing request' do
    command "openssl req -new -nodes -out #{new_resource.ssl_directory}/#{new_resource.csr_file} -keyout #{new_resource.ssl_directory}/#{new_resource.server_private_key_file} -config #{new_resource.ssl_directory}/#{new_resource.csr_configuration_file}"
  end
end

action :generate_server_extension_file do
  vhost_urls_array = DemoStructureHelper.get_vhost_urls
  template 'Create server extension file for Subject Alternative Names' do
    source "#{new_resource.server_extension_file}.erb"
    path "#{new_resource.ssl_directory}/#{new_resource.server_extension_file}"
    owner 'root'
    group 'root'
    mode '755'
    variables({ demo_urls: vhost_urls_array })
  end
end

action :generate_server_certificate do
  execute 'Generate server certificate' do
    command "openssl x509 -req -in #{new_resource.ssl_directory}/#{new_resource.csr_file} -CA #{new_resource.ssl_directory}/#{new_resource.ca_certificate_file} -CAkey #{new_resource.ssl_directory}/#{new_resource.ca_private_key_file} -CAcreateserial -out #{new_resource.ssl_directory}/#{new_resource.server_certificate_file} -days #{new_resource.certificate_days} -extfile #{new_resource.ssl_directory}/#{new_resource.server_extension_file}"
    only_if do
      ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.csr_file}") &&
        ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.ca_certificate_file}") &&
        ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.ca_private_key_file}") &&
        ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.server_extension_file}")
    end
  end
end

action :refresh_certificate_list do
  execute 'Refresh the certificate list' do
    command 'update-ca-certificates --fresh'
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.server_certificate_file}") }
  end
end

action :update_ssl_permissions do
  execute 'Set the VM user as the ssl owner' do
    command "chown -R #{new_resource.user}:#{new_resource.group} #{new_resource.ssl_directory}/*"
    only_if { ::Dir.exist?(new_resource.ssl_directory) }
  end

  execute 'Update ssl directory permissions' do
    command "chmod 775 #{new_resource.ssl_directory}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.server_certificate_file}") }
  end

  execute 'Update server private key file permissions' do
    command "chmod 640 #{new_resource.ssl_directory}/#{new_resource.server_private_key_file}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.server_private_key_file}") }
  end

  execute 'Update server certificate file permissions' do
    command "chmod 640 #{new_resource.ssl_directory}/#{new_resource.server_certificate_file}"
    only_if { ::File.exist?("#{new_resource.ssl_directory}/#{new_resource.server_certificate_file}") }
  end
end

action :export_ssl_certificate do
  execute 'Export certificate' do
    command "cp /etc/ssl/server.crt /vagrant/certificate/#{new_resource.common_name}.crt"
    only_if { ::File.exist?('/etc/ssl/server.crt') }
  end
end
