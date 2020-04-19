#
# Cookbook:: samba
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_samba = node[:infrastructure][:samba][:use]

# Recipes
include_recipe 'samba::uninstall'
if use_samba
    include_recipe 'samba::install'
    include_recipe 'samba::configure'
end
