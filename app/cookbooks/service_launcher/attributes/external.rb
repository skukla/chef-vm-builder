#
# Cookbook:: service_launcher
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:service_launcher][:init][:web_root] = node[:init][:webserver][:web_root]
default[:service_launcher][:init][:magento][:build_action] = node[:init][:magento][:build_action]

include_attribute "elasticsearch::default"
default[:service_launcher][:elasticsearch][:use] = node[:elasticsearch][:use]

include_attribute "mailhog::default"
default[:service_launcher][:mailhog][:use] = node[:mailhog][:use]

include_attribute "samba::default"
default[:service_launcher][:samba][:use] = node[:samba][:use]

include_attribute "webmin::default"
default[:service_launcher][:webmin][:use] = node[:webmin][:use]