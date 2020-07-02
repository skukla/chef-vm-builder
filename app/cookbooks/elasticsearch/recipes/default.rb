#
# Cookbook:: elasticsearch
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe "elasticsearch::uninstall"
include_recipe "elasticsearch::install"
include_recipe "elasticsearch::configure"




