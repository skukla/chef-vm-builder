#
# Cookbook:: php
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:php][:init][:user] = node[:init][:os][:user]
default[:php][:init][:timezone] = node[:init][:os][:timezone]
default[:php][:init][:webserver_type] = node[:init][:webserver][:type]
default[:php][:init][:apache_package_list] = node[:init][:webserver][:apache_package_list]

include_attribute "mailhog::default"
default[:php][:sendmail_path] = node[:mailhog][:sendmail_path]