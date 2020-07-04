#
# Cookbook:: magento_internal
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# The PMET team uses a branch structure which ignores any patches (p1, p2, etc.)
default[:magento_internal][:branch] =  "pmet-#{node[:magento_internal][:magento][:version].split("-")[0]}-ref"
