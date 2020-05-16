#
# Cookbook:: elasticsearch
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe "elasticsearch::uninstall"
if node[:elasticsearch][:use]
    include_recipe "elasticsearch::install_java"
    include_recipe "elasticsearch::install"
    include_recipe "elasticsearch::configure"
end
