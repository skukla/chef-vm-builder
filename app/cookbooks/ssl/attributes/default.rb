#
# Cookbook:: ssl
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:ssl][:port] = 443
default[:ssl][:key_size] = 2048
default[:ssl][:certificate_days] = 3650
default[:ssl][:directory] = '/etc/ssl'
default[:ssl][:chainfile_directory] = '/etc/ssl/certs'
default[:ssl][:ca_private_key_file] = 'private_key.pem'
default[:ssl][:ca_certificate_file] = 'ca.pem'
default[:ssl][:ca_serial_file] = 'ca.srl'
default[:ssl][:csr_configuration_file] = 'server.csr.cnf'
default[:ssl][:csr_file] = 'server.csr'
default[:ssl][:server_private_key_file] = 'server.key'
default[:ssl][:server_extension_file] = 'server.ext'
default[:ssl][:server_certificate_file] = 'server.crt'
default[:ssl][:chainfile] = 'ca-certificates.crt'
default[:ssl][:country] = 'US'
default[:ssl][:region] = 'California'
default[:ssl][:locality] = 'Los Angeles'
default[:ssl][:organization] = 'Kukla Certificate Authority'
default[:ssl][:organizational_unit] = 'Commerce'
default[:ssl][:country] = 'US'

include_attribute 'ssl::external'
DemoStructureHelper.get_vhost_data(node[:ssl][:init][:demo_structure]).each do |vhost|
  if (vhost[:scope] == 'website' && vhost[:code] == 'base') ||
     (vhost[:scope] == 'store_view' && vhost[:code] == 'default')
    default[:ssl][:common_name] = vhost[:url]
  end
end
