#
# Cookbook:: webmin
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes


# Recipes
include_recipe 'webmin::uninstall'
include_recipe 'webmin::install'
include_recipe 'webmin::configure'
