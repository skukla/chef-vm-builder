#
# Cookbook:: nginx
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:nginx][:package_list] = ["nginx"]
default[:nginx][:client_max_body_size] = "100M"
default[:nginx][:fastcgi_buffers] = "16 16k"
default[:nginx][:fastcgi_buffer_size] = "32k"
default[:nginx][:http_port] = 80