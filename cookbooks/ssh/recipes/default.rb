#
# Cookbook:: ssh
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
include_recipe 'ssh::configure_ssh'
include_recipe 'ssh::upload_keys'
