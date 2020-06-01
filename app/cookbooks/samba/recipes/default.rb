#
# Cookbook:: samba
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe 'samba::uninstall'
if node[:samba][:use]
    include_recipe 'samba::install'
    include_recipe 'samba::configure'
end
