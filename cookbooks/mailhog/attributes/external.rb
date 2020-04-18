#
# Cookbook:: mailhog
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in php attributes
include_attribute 'php::default'
default[:infrastructure][:mailhog][:php][:supported_versions] = node[:infrastructure][:php][:supported_versions]
