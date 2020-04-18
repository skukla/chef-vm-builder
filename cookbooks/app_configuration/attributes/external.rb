#
# Cookbook:: app_configuration
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in other cookbook attributes
include_attribute 'composer::default'

default[:application][:composer][:filename] = node[:infrastructure][:composer][:filename]