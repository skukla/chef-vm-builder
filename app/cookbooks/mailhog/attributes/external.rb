#
# Cookbook:: mailhog
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "php::default"
default[:mailhog][:php][:version] = node[:php][:version]