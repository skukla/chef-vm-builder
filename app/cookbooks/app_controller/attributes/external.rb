#
# Cookbook:: app_controller
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute 'init::default'
default[:app_controller][:init][:web_root] = node[:init][:webserver][:web_root]
default[:app_controller][:init][:magento][:build_action] = node[:init][:magento][:build_action]

include_attribute 'elasticsearch::default'
default[:app_controller][:elasticsearch][:use] = node[:elasticsearch][:use]

include_attribute 'mailhog::default'
default[:app_controller][:mailhog][:use] = node[:mailhog][:use]

include_attribute 'samba::default'
default[:app_controller][:samba][:use] = node[:samba][:use]

include_attribute 'webmin::default'
default[:app_controller][:webmin][:use] = node[:webmin][:use]