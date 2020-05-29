#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe "nginx::install"
include_recipe "nginx::ssl"
include_recipe "nginx::configure_initial"
include_recipe "nginx::create_web_root"
