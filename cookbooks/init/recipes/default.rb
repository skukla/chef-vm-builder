#
# Cookbook:: init
# Recipe:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
update_os = node[:infrastructure][:os][:update]

include_recipe 'init::update_os' if update_os
include_recipe 'init::install_packages'
include_recipe 'init::install_motd'
