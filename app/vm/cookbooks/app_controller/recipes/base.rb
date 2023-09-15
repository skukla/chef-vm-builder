# Cookbook:: app_controller
# Recipe:: base
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_recipe 'init::default'
include_recipe 'init::motd'
include_recipe 'vm_cli::default'
include_recipe 'vm_cli::install'
include_recipe 'ssh::default'
