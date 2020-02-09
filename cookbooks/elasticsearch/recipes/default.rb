#
# Cookbook:: elasticsearch
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes


# Recipes
include_recipe 'elasticsearch::uninstall'
include_recipe 'elasticsearch::uninstall_java'
include_recipe 'elasticsearch::install_java'
include_recipe 'elasticsearch::install'
include_recipe 'elasticsearch::configure'
