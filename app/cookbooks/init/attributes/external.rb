#
# Cookbook:: init
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "mailhog::default"
default[:init][:use_mailhog] = node[:mailhog][:use]

include_attribute "webmin::default"
default[:init][:use_webmin] = node[:webmin][:use]
