#
# Cookbook:: service_launcher
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:service_launcher][:init][:webserver_type] = node[:init][:webserver][:type]

include_attribute "elasticsearch::default"
default[:service_launcher][:elasticsearch][:use] = node[:elasticsearch][:use]

include_attribute "mailhog::default"
default[:service_launcher][:mailhog][:use] = node[:mailhog][:use]

include_attribute "samba::default"
default[:service_launcher][:samba][:use] = node[:samba][:use]

include_attribute "webmin::default"
default[:service_launcher][:webmin][:use] = node[:webmin][:use]