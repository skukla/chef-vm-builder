#
# Cookbook:: webmin
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_webmin = node[:infrastructure][:webmin][:use]

# Recipes
include_recipe 'webmin::uninstall'
if use_webmin
    include_recipe 'webmin::install'
    include_recipe 'webmin::configure'
end
