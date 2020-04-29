#
# Cookbook:: nginx
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute 'php::default'
default[:nginx][:backend] =  node[:php][:backend]
