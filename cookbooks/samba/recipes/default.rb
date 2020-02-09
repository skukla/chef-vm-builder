#
# Cookbook:: samba
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes


# Recipes
include_recipe 'samba::uninstall'
include_recipe 'samba::install'
include_recipe 'samba::configure'
