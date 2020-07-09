#
# Cookbook:: php
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:php][:init][:user] = node[:init][:os][:user]
default[:php][:init][:timezone] = node[:init][:os][:timezone]
default[:php][:init][:webserver_type] = node[:init][:webserver][:type]

include_attribute "mailhog::default"
default[:php][:sendmail_path] = node[:mailhog][:sendmail_path]

include_attribute "apache::default"
default[:php][:apache][:package_list] = node[:apache][:package_list]