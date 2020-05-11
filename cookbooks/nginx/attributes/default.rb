#
# Cookbook:: nginx
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:nginx][:web_root] = "/var/www/magento"
default[:nginx][:client_max_body_size] = "100M"
default[:nginx][:http_port] = 80
default[:nginx][:ssl_port] = 443
default[:nginx][:ssl_key_file] = "localhost.key"
default[:nginx][:ssl_certificate_file] = "localhost.crt"
default[:nginx][:ssl_organization] = node[:vm][:name]
default[:nginx][:ssl_locality] = "Los Angeles"
default[:nginx][:ssl_region] = "California"
default[:nginx][:ssl_country] = "US"
