#
# Cookbook:: nginx
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

default[:infrastructure][:webserver][:ssl_files] = {
    key_file: 'localhost.key',
    certificate_file: 'localhost.crt'
}
default[:infrastructure][:webserver][:ssl_options] = {
    country: 'US',
    state: 'California',
    locality: 'Los Angeles',
    organization: 'Luma',
    common_name: node[:fqdn]
}
