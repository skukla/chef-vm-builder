#
# Cookbook:: ssl
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:ssl][:port] = 443
default[:ssl][:cert_directory] = "/usr/local/share/ca-certificates"
default[:ssl][:key_directory] = "/etc/ssl/private"
default[:ssl][:chainfile] = "ca-certificates.crt"
default[:ssl][:organization] = node[:vm][:name]
default[:ssl][:locality] = "Los Angeles"
default[:ssl][:region] = "California"
default[:ssl][:country] = "US"