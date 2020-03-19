#
# Cookbook:: mailhog
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.

# Attributes
use_mailhog = node[:infrastructure][:mailhog][:use]

# Recipes
if use_mailhog
    include_recipe 'mailhog::uninstall'
    include_recipe 'mailhog::uninstall_golang'
    include_recipe 'mailhog::install_golang'
    include_recipe 'mailhog::install'
    include_recipe 'mailhog::configure'
end
