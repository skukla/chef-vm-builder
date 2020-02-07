#
# Cookbook:: nginx
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in attributes from other cookbooks
include_attribute 'init::default'
include_attribute 'php::default'

default[:infrastructure][:webserver][:user] = node[:vm][:user]
default[:infrastructure][:webserver][:group] = node[:vm][:group]
default[:infrastructure][:webserver][:fpm_backend] =  node[:infrastructure][:php][:fpm_options][:backend]
