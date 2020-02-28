#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes


# Recipes
include_recipe 'nginx::install'
include_recipe 'nginx::install_ssl'
include_recipe 'nginx::configure'
