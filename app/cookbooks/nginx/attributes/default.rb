#
# Cookbook:: nginx
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:nginx][:web_root] = "/var/www/magento"
default[:nginx][:client_max_body_size] = "100M"
default[:nginx][:http_port] = 80