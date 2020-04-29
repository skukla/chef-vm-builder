#
# Cookbook:: custom_modules
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_attribute 'composer::default'
default[:custom_modules][:composer][:filename] = node[:composer][:filename]