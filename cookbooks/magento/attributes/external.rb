#
# Cookbook:: magento
# Attribute:: external
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Bring in attributes from other cookbooks
include_attribute 'composer::default'

default[:application][:composer][:install_dir] = node[:infrastructure][:composer][:install_dir]
default[:application][:composer][:filename] = node[:infrastructure][:composer][:filename]
