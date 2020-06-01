#
# Cookbook:: mailhog
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe 'mailhog::uninstall'
if node[:mailhog][:use]
    include_recipe 'mailhog::install_golang'
    include_recipe 'mailhog::install'
    include_recipe 'mailhog::configure'
end
