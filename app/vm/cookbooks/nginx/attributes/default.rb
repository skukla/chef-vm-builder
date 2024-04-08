# Cookbook:: nginx
# Attribute:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

default[:nginx][:package_list] = ['nginx']
default[:nginx][:http_port] = '80'
default[:nginx][:client_max_body_size] = '500M'
default[:nginx][:fastcgi_buffers] = '16 16k'
default[:nginx][:fastcgi_buffer_size] = '32k'
default[:nginx][:web_root] = '/var/www/magento'
default[:nginx][:tmp_dir] = '/var/www/tmp'
