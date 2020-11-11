#
# Cookbook:: php
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute "init::default"
include_attribute "init::override"
default[:php][:init][:user] = node[:init][:os][:user]
default[:php][:init][:timezone] = node[:init][:os][:timezone]

include_attribute "mailhog::default"
default[:php][:sendmail_path] = node[:mailhog][:sendmail_path]