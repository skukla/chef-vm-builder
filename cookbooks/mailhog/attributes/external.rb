#
# Cookbook:: mailhog
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "php::default"
default[:mailhog][:php_version] = node[:php][:version]