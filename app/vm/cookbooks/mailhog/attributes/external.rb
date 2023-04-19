# Cookbook:: mailhog
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
include_attribute 'init::override'
default[:mailhog][:init][:user] = node[:init][:os][:user]
default[:mailhog][:os][:codename] = node[:init][:os][:codename]
default[:mailhog][:vm][:provider] = node[:init][:vm][:provider]

include_attribute 'php::default'
default[:mailhog][:php][:version] = node[:php][:version]
