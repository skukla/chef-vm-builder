#
# Cookbook:: php
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes


# Recipes
include_recipe 'php::install'
include_recipe 'php::configure'
include_recipe 'php::uninstall_apache'
