# Cookbook:: mailhog
# Recipe:: default
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

include_recipe 'mailhog::install_golang'
include_recipe 'mailhog::mailhog'
include_recipe 'mailhog::configure_sendmail'
