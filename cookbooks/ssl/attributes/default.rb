#
# Cookbook:: ssl
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:ssl][:key_file] = "localhost.key"
default[:ssl][:certificate_file] = "localhost.crt"
default[:ssl][:organization] = node[:vm][:name]
default[:ssl][:locality] = "Los Angeles"
default[:ssl][:region] = "California"
default[:ssl][:country] = "US"