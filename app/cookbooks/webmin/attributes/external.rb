# Cookbook:: webmin
# Attribute:: external
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_attribute 'init::default'
default[:webmin][:init][:user] = node[:init][:os][:user]
