#
# Cookbook:: mailhog
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in init attributes
include_attribute 'init::default'
include_attribute 'php::default'

default[:infrastructure][:mailhog][:conf_options] = {
    user: node[:vm][:user],
    owner: node[:vm][:user],
    group: node[:vm][:group]
}
default[:infrastructure][:mailhog][:php][:supported_versions] = node[:infrastructure][:php][:supported_versions]
