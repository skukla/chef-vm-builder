#
# Cookbook:: elasticsearch
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_elasticsearch = node[:infrastructure][:elasticsearch][:use]

# Recipes
if use_elasticsearch
    include_recipe 'elasticsearch::uninstall'
    include_recipe 'elasticsearch::uninstall_java'
    include_recipe 'elasticsearch::install_java'
    include_recipe 'elasticsearch::install'
    include_recipe 'elasticsearch::configure'
end
