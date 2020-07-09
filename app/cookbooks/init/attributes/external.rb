#
# Cookbook:: init
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "apache::default"
default[:init][:webserver][:apache_package_list] = node[:apache][:package_list]

include_attribute "nginx::default"
default[:init][:webserver][:nginx_package_list] = node[:nginx][:package_list]

include_attribute "mailhog::default"
default[:init][:use_mailhog] = node[:mailhog][:use]

include_attribute "webmin::default"
default[:init][:use_webmin] = node[:webmin][:use]
