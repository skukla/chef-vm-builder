#
# Cookbook:: webmin
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe 'webmin::uninstall'
if node[:webmin][:use]
    include_recipe 'webmin::install'
    include_recipe 'webmin::configure'
end
