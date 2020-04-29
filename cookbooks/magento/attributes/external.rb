#
# Cookbook:: magento
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "composer::default"
default[:magento][:composer][:install_dir] = node[:composer][:install_dir]
default[:magento][:composer][:filename] = node[:composer][:filename]

include_attribute "nginx::default"
default[:magento][:http_port] = node[:nginx][:http_port]
default[:magento][:client_max_body_size] = node[:nginx][:client_max_body_size]

include_attribute "php::default"
default[:magento][:fpm_backend] = node[:php][:backend]
default[:magento][:fpm_port] = node[:php][:port]

include_attribute "init::default"
default[:magento][:timezone] = node[:init][:timezone] 