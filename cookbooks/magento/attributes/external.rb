#
# Cookbook:: magento
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:magento][:timezone] = node[:init][:timezone]

include_attribute "php::default"
default[:magento][:php_version] = node[:php][:version]
default[:magento][:fpm_backend] = node[:php][:backend]
default[:magento][:fpm_port] = node[:php][:port]

include_attribute "nginx::default"
default[:magento][:client_max_body_size] = node[:nginx][:client_max_body_size]
default[:magento][:http_port] = node[:nginx][:http_port]
default[:magento][:ssl_port] = node[:nginx][:ssl_port]
default[:magento][:ssl_key_file] = node[:nginx][:ssl_key_file]
default[:magento][:ssl_certificate_file] = node[:nginx][:ssl_certificate_file]

include_attribute "composer::default"
default[:magento][:composer_filename] = node[:composer][:filename]

include_attribute "elasticsearch::default"
default[:magento][:use_elasticsearch] = node[:elasticsearch][:use]