#
# Cookbook:: php
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in init attributes
include_attribute 'init::default'

default[:infrastructure][:php][:fpm_options] = {
    owner: node[:vm][:user],
    user: node[:vm][:user],
    group: node[:vm][:group],
    backend: '127.0.0.1',
    port: node[:infrastructure][:php][:port]
}
