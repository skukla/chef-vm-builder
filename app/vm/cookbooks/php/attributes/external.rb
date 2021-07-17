# Cookbook:: php
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
include_attribute 'init::override'
default[:php][:init][:user] = node[:init][:os][:user]
default[:php][:init][:timezone] = node[:init][:os][:timezone]

include_attribute 'nginx::default'
default[:php][:nginx][:web_root] = node[:nginx][:web_root]

include_attribute 'mailhog::default'
default[:php][:sendmail_path] = node[:mailhog][:sendmail_path]
