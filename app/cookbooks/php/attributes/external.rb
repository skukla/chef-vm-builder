#
# Cookbook:: php
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
default[:php][:user] = node[:init][:os][:user]
default[:php][:timezone] = node[:init][:os][:timezone]

include_attribute "mailhog::default"
default[:php][:sendmail_path] = node[:mailhog][:sendmail_path]