# Cookbook:: mysql
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
include_attribute 'init::override'
default[:mysql][:os][:codename] = node[:init][:os][:codename]
