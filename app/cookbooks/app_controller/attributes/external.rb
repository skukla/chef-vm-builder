# Cookbook:: app_controller
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'nginx::default'
default[:app_controller][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute 'elasticsearch::default'
default[:app_controller][:elasticsearch][:use] = node[:elasticsearch][:use]

include_attribute 'mailhog::default'
default[:app_controller][:mailhog][:use] = node[:mailhog][:use]

include_attribute 'samba::default'
default[:app_controller][:samba][:use] = node[:samba][:use]

include_attribute 'webmin::default'
default[:app_controller][:webmin][:use] = node[:webmin][:use]

include_attribute 'magento::default'
default[:app_controller][:magento][:build_action] = node[:magento][:build][:action]
